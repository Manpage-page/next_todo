import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:next_todo/application/services/task_extract_service.dart';

/// Thrown when the Gemini API key is missing.
class MissingGeminiApiKeyException implements Exception {
  const MissingGeminiApiKeyException();

  @override
  String toString() {
    return 'MissingGeminiApiKeyException: Set GEMINI_API_KEY via --dart-define before running the app.';
  }
}

final geminiApiKeyProvider = Provider<String>((ref) {
  const apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  if (apiKey.isEmpty) {
    throw const MissingGeminiApiKeyException();
  }

  return apiKey;
});

final geminiModelProvider = Provider<GenerativeModel>((ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  return GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
});

final taskExtractServiceProvider = Provider<TaskExtractService>((ref) {
  final model = ref.watch(geminiModelProvider);
  return TaskExtractService(model);
});
