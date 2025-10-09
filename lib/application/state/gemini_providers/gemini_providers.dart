import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/services/gemini_client.dart';
import 'package:next_todo/application/services/gemini_proxy_client.dart';
import 'package:next_todo/application/services/gemini_gga_client.dart';
import 'package:next_todo/application/services/task_extract_service.dart';

final geminiClientProvider = Provider<GeminiClient>((ref) {
  if (kIsWeb) {
    const endpoint = String.fromEnvironment('PROXY_URL'); // WorkersのURL
    const token = String.fromEnvironment('APP_TOKEN'); // 任意
    return GeminiProxyClient(endpoint, appToken: token.isEmpty ? null : token);
  } else {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    return GeminiGgaClient(apiKey);
  }
});

final taskExtractServiceProvider = Provider<TaskExtractService>((ref) {
  return TaskExtractService(ref.read(geminiClientProvider));
});
