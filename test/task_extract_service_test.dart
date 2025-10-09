import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:next_todo/application/services/task_extract_service.dart';
import 'package:test/test.dart';

void main() {
  group('TaskExtractService.splitTasks', () {
    test('returns empty list when input is blank', () async {
      final service = TaskExtractService.test(
        request: ({required prompt, required config}) async => '[]',
      );

      final result = await service.splitTasks('   ');
      expect(result, isEmpty);
    });

    test('parses Gemini response into TaskDraft objects', () async {
      String? capturedPrompt;
      GenerationConfig? capturedConfig;

      final service = TaskExtractService.test(
        request: ({required prompt, required config}) async {
          capturedPrompt = prompt;
          capturedConfig = config;
          return '[{"title":"資料作成","note":"営業資料","due":"2025-05-10","priority":"high"}]';
        },
        clock: () => DateTime.utc(2025, 4, 1),
      );

      final result = await service.splitTasks('来週までに営業資料を仕上げる');

      expect(result, hasLength(1));
      expect(result.first.title, '資料作成');
      expect(result.first.note, '営業資料');
      expect(result.first.due, '2025-05-10');
      expect(result.first.priority, 'high');

      expect(capturedPrompt, isNotNull);
      expect(capturedPrompt, contains('2025'));
      expect(capturedPrompt, contains('来週までに営業資料を仕上げる'));

      expect(capturedConfig, isNotNull);
      expect(capturedConfig!.responseMimeType, 'application/json');
      expect(capturedConfig!.temperature, closeTo(0.2, 1e-9));
      expect(capturedConfig!.maxOutputTokens, 1024);
    });

    test('accepts JSON wrapped in code fences', () async {
      final service = TaskExtractService.test(
        request:
            ({required prompt, required config}) async =>
                '```json\n[{"title":"会議準備"}]\n```',
      );

      final result = await service.splitTasks('明日の会議の準備をする');

      expect(result, hasLength(1));
      expect(result.first.title, '会議準備');
    });

    test(
      'attempts to extract array even when extra text is returned',
      () async {
        final service = TaskExtractService.test(
          request:
              ({required prompt, required config}) async =>
                  'Here you go!\n[ {"title": "見積書作成"} ]\nThanks!',
        );

        final result = await service.splitTasks('見積書作成');

        expect(result, hasLength(1));
        expect(result.single.title, '見積書作成');
      },
    );

    test(
      'throws TaskExtractionException when response is not valid JSON',
      () async {
        final service = TaskExtractService.test(
          request: ({required prompt, required config}) async => 'invalid-json',
        );

        await expectLater(
          service.splitTasks('テスト'),
          throwsA(
            isA<TaskExtractionException>().having(
              (e) => e.message,
              'message',
              contains('解析できませんでした'),
            ),
          ),
        );
      },
    );

    test('wraps unexpected errors into TaskExtractionException', () async {
      final service = TaskExtractService.test(
        request:
            ({required prompt, required config}) async =>
                throw Exception('boom'),
      );

      await expectLater(
        service.splitTasks('テスト'),
        throwsA(
          isA<TaskExtractionException>().having(
            (e) => e.message,
            'message',
            contains('予期しない'),
          ),
        ),
      );
    });
  });
}
