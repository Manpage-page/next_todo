import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:next_todo/application/services/task_extract_service.dart';

final geminiModelProvider = Provider<GenerativeModel>((ref) {
  const apiKey = String.fromEnvironment('GEMINI_API_KEY');
  return GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
});

final taskExtractServiceProvider = Provider<TaskExtractService>((ref) {
  return TaskExtractService(ref.read(geminiModelProvider));
});
