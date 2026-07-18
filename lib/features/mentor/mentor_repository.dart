import 'package:dio/dio.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/features/mentor/mentor_models.dart';

class MentorRepository {
  MentorRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  Future<MentorAnswer> analyze({String? question}) async {
    try {
      final res = await _client.raw.post<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/roadmap/mentor/analyze',
        data: {
          if (question != null && question.trim().isNotEmpty)
            'question': question.trim(),
        },
      );
      return MentorAnswer.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Mentor analyze failed');
    }
  }
}
