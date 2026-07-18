import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/features/jobs/jobs_models.dart';
import 'package:goroute_mobile/features/jobs/jobs_repository.dart';

void main() {
  late Dio dio;
  late JobsRepository repo;

  setUp(() {
    dio = Dio();
    repo = JobsRepository(
      client: ApiClient(
        config: AppConfig.localhost,
        sessionStore: SessionStore(kv: MemorySecureKv()),
        dio: dio,
      ),
    );
  });

  test('JobMatch.fromJson maps score fields', () {
    final m = JobMatch.fromJson({
      'jobId': 'j1',
      'title': 'Dev',
      'companyName': 'Acme',
      'matchScore': 87,
      'fullyQualified': false,
      'city': 'SP',
      'state': 'SP',
    });
    expect(m.matchScore, 87);
    expect(m.locationDisplay, 'SP, SP');
  });

  test('fetchMatches maps list', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/jobs/match'));
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: [
                {
                  'jobId': 'j1',
                  'title': 'Dev',
                  'companyName': 'Acme',
                  'matchScore': 100,
                  'fullyQualified': true,
                },
              ],
            ),
          );
        },
      ),
    );
    final list = await repo.fetchMatches();
    expect(list, hasLength(1));
    expect(list.first.fullyQualified, isTrue);
  });

  test('apply throws JOB_APPLY_NOT_ELIGIBLE', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 400,
                data: {
                  'code': 'JOB_APPLY_NOT_ELIGIBLE',
                  'message': 'Need 100%',
                  'matchScore': 70,
                },
              ),
              type: DioExceptionType.badResponse,
            ),
          );
        },
      ),
    );
    try {
      await repo.apply('j1');
      fail('expected ApiException');
    } on ApiException catch (e) {
      expect(e.isNotEligible, isTrue);
    }
  });

  test('fetchNarrative maps summary and closingSkills', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/match-narrative'));
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'jobId': 'j1',
                'title': 'Dev',
                'matchScore': 80,
                'fullyQualified': false,
                'source': 'heuristic',
                'summary': 'Close React gap',
                'closingSkills': [
                  {'slug': 'react', 'label': 'React', 'minLevel': 'intermediate'},
                ],
              },
            ),
          );
        },
      ),
    );
    final n = await repo.fetchNarrative('j1');
    expect(n.summary, 'Close React gap');
    expect(n.closingSkills.first.label, 'React');
  });
}
