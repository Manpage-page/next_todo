import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/services/gemini_client.dart';
import 'package:next_todo/application/services/gemini_proxy_client.dart';
import 'package:next_todo/application/services/gemini_gga_client.dart';
import 'package:next_todo/application/services/task_extract_service.dart';

final geminiClientProvider = Provider<GeminiClient>((ref) {
  if (kIsWeb) {
    // Webは必ずプロキシ経由（APIキーを埋め込まない）
    const endpoint = String.fromEnvironment('API_PROXY_URL');
    return GeminiProxyClient(endpoint);
  } else {
    // ネイティブでは暫定的に直叩き可（本当はプロキシ推奨）
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    return GeminiGgaClient(apiKey);
  }
});

final taskExtractServiceProvider = Provider<TaskExtractService>((ref) {
  return TaskExtractService(ref.read(geminiClientProvider));
});
