import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/features/weekly/weekly_models.dart';
import 'package:goroute_mobile/features/weekly/weekly_repository.dart';

void main() {
  late Dio dio;
  late WeeklyPlanRepository repo;

  setUp(() {
    dio = Dio();
    repo = WeeklyPlanRepository(
      client: ApiClient(
        config: AppConfig.localhost,
        sessionStore: SessionStore(kv: MemorySecureKv()),
        dio: dio,
      ),
    );
  });

  test('WeeklyPlan.fromJson maps tasks and focus', () {
    final plan = WeeklyPlan.fromJson({
      'weekKey': '2026-07-13',
      'status': 'active',
      'weekFocus': {'slug': 'react', 'label': 'React'},
      'progressPercent': 50,
      'allTasksCompleted': false,
      'tasks': [
        {
          'id': 't2',
          'type': 'practice',
          'title': 'B',
          'skillSlug': 'react',
          'completed': false,
          'sortOrder': 2,
        },
        {
          'id': 't1',
          'type': 'learn',
          'title': 'A',
          'skillSlug': 'react',
          'completed': true,
          'sortOrder': 1,
        },
      ],
    });
    expect(plan.weekFocusLabel, 'React');
    expect(plan.tasks.first.id, 't1');
    expect(plan.tasks.last.id, 't2');
  });

  test('fetchCurrent throws PREMIUM_REQUIRED on 403', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 403,
                data: {
                  'code': 'PREMIUM_REQUIRED',
                  'message': 'Assinatura necessária',
                  'feature': 'weekly_plan',
                },
              ),
              type: DioExceptionType.badResponse,
            ),
          );
        },
      ),
    );

    try {
      await repo.fetchCurrent();
      fail('expected ApiException');
    } on ApiException catch (e) {
      expect(e.code, 'PREMIUM_REQUIRED');
      expect(e.isPremiumRequired, isTrue);
    }
  });

  test('completeTask posts to tasks/:id/complete', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/weekly-plan/tasks/t1/complete'));
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'weekKey': '2026-07-13',
                'status': 'active',
                'weekFocus': {'slug': 'x', 'label': 'X'},
                'progressPercent': 100,
                'allTasksCompleted': true,
                'tasks': <dynamic>[],
              },
            ),
          );
        },
      ),
    );
    final plan = await repo.completeTask('t1');
    expect(plan.allTasksCompleted, isTrue);
  });
}
