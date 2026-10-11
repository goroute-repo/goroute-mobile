import 'package:dio/dio.dart';

import '../../core/auth/session_store.dart';
import '../../core/network/api_client.dart';

class AuthException implements Exception {
  AuthException(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => message;
}

class LoginResult {
  const LoginResult({
    required this.role,
    required this.onboardingCompleted,
    this.mfaRequired = false,
    this.tempToken,
  });

  final String role;
  final bool onboardingCompleted;
  final bool mfaRequired;
  final String? tempToken;
}

class AuthRepository {
  AuthRepository({
    required ApiClient client,
    required SessionStore sessionStore,
  })  : _client = client,
        _sessionStore = sessionStore;

  final ApiClient _client;
  final SessionStore _sessionStore;

  Future<LoginResult> loginProfessional({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.raw.post<Map<String, dynamic>>(
        '${_client.authBaseUrl}/users/login',
        data: {'email': email.trim(), 'password': password},
        options: Options(
          headers: {'X-Application-From': _client.applicationFrom},
        ),
      );
      final data = res.data ?? {};
      if (data['mfaRequired'] == true) {
        final tempToken = data['tempToken'] as String?;
        if (tempToken == null || tempToken.isEmpty) {
          throw AuthException(
            'MFA required but tempToken missing.',
            code: 'MFA_TOKEN_MISSING',
          );
        }
        return LoginResult(
          role: (data['role'] as String?) ?? 'professional',
          onboardingCompleted: data['onboardingCompleted'] == true,
          mfaRequired: true,
          tempToken: tempToken,
        );
      }
      await _persistMobileSession(data, res);
      return LoginResult(
        role: (data['role'] as String?) ?? 'professional',
        onboardingCompleted: data['onboardingCompleted'] == true,
        mfaRequired: false,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) {
        throw AuthException('Invalid email or password.', code: 'UNAUTHORIZED');
      }
      throw AuthException(
        e.message ?? 'Network error',
        code: 'NETWORK',
      );
    }
  }

  /// Cadastro de conta profissional — espelha `registerUser` do
  /// goroute-frontend (POST /users/register). Não faz login automático:
  /// o backend exige um login separado depois, igual ao fluxo web.
  Future<void> registerProfessional({
    required String email,
    required String password,
  }) async {
    try {
      await _client.raw.post<Map<String, dynamic>>(
        '${_client.authBaseUrl}/users/register',
        data: {
          'email': email.trim(),
          'password': password,
          'acceptedTerms': true,
          // ponytail: versões replicadas do goroute-frontend
          // (core/legal/legal.config.ts) — mantenha os dois em sincronia
          // com goroute-service-auth/src/common/legal-versions.ts.
          'termsVersion': '2026-06-04',
          'privacyVersion': '2026-06-04',
        },
        options: Options(
          headers: {'X-Application-From': _client.applicationFrom},
        ),
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final code = (e.response?.data is Map)
          ? (e.response!.data as Map)['error'] as String?
          : null;
      if (status == 409 || code == 'USER_EXISTS') {
        throw AuthException('Email already registered.', code: 'USER_EXISTS');
      }
      if (code == 'WEAK_PASSWORD') {
        throw AuthException('Weak password.', code: 'WEAK_PASSWORD');
      }
      if (code == 'TERMS_NOT_ACCEPTED' ||
          code == 'TERMS_VERSION_MISMATCH' ||
          code == 'PRIVACY_VERSION_MISMATCH') {
        throw AuthException('Terms not accepted.', code: 'TERMS_NOT_ACCEPTED');
      }
      throw AuthException(e.message ?? 'Network error', code: 'NETWORK');
    }
  }

  Future<LoginResult> verifyMfa({
    required String tempToken,
    required String code,
  }) async {
    try {
      final res = await _client.raw.post<Map<String, dynamic>>(
        '${_client.authBaseUrl}/users/mfa/verify',
        data: {'tempToken': tempToken, 'code': code.trim()},
        options: Options(
          headers: {'X-Application-From': _client.applicationFrom},
        ),
      );
      final data = res.data ?? {};
      await _persistMobileSession(data, res);
      return LoginResult(
        role: (data['role'] as String?) ?? 'professional',
        onboardingCompleted: data['onboardingCompleted'] == true,
        mfaRequired: false,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 400) {
        throw AuthException('Invalid MFA code.', code: 'MFA_INVALID');
      }
      throw AuthException(
        e.message ?? 'Network error',
        code: 'NETWORK',
      );
    }
  }

  Future<void> _persistMobileSession(
    Map<String, dynamic> data,
    Response<Map<String, dynamic>> res,
  ) async {
    final sessionId = data['sessionId'] as String?;
    final mapApiHash =
        data['mapApiHash'] as String? ?? res.headers.value('x-mapper-api');
    if (sessionId == null ||
        sessionId.isEmpty ||
        mapApiHash == null ||
        mapApiHash.isEmpty) {
      throw AuthException(
        'Auth did not return mobile session credentials.',
        code: 'MOBILE_SESSION_MISSING',
      );
    }
    final role = (data['role'] as String?) ?? 'professional';
    await _sessionStore.saveSession(
      sessionId: sessionId,
      mapperApi: mapApiHash,
      role: role,
    );
  }

  Future<void> logout() => _sessionStore.clear();
}
