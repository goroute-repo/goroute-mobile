import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/features/mentor/mentor_models.dart';
import 'package:goroute_mobile/features/mentor/mentor_repository.dart';

void main() {
  late Dio dio;
  late MentorRepository repo;

  setUp(() {
    dio = Dio();
    repo = MentorRepository(
      client: ApiClient(
        config: AppConfig.localhost,
        sessionStore: SessionStore(kv: MemorySecureKv()),
        dio: dio,
      ),
    );
  });

  test('analyze posts question and maps answer', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/roadmap/mentor/analyze'));
          expect(options.data['question'], 'What should I learn next?');
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'source': 'managed',
                'scope': 'in_track',
                'summary': 'Focus on React. Start the React node',
                'intro': 'Next step',
                'diagnosis': ['Close React gap'],
                'immediateAction': 'Start the React node',
              },
            ),
          );
        },
      ),
    );

    final answer =
        await repo.analyze(question: 'What should I learn next?');
    expect(answer.scope, 'in_track');
    expect(answer.summary, 'Focus on React. Start the React node');
    expect(answer.displayText, contains('Start the React node'));
    expect(answer.displayText, contains('Close React gap'));
  });

  test('MentorAnswer.fromJson tolerates missing optional fields', () {
    final a = MentorAnswer.fromJson({'summary': 'ok', 'source': 'heuristic'});
    expect(a.diagnosis, isEmpty);
    expect(a.displayText, 'ok');
  });
}
