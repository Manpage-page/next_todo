// application/services/gemini_proxy_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:next_todo/application/services/gemini_client.dart';

class GeminiProxyClient implements GeminiClient {
  final String endpoint; // 例: https://gemini-proxy.your-domain.workers.dev
  GeminiProxyClient(this.endpoint);

  @override
  Future<String> generate(
    String prompt, {
    String model = 'gemini-2.5-flash',
    String? system,
  }) async {
    final res = await http.post(
      Uri.parse('$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': model,
        'prompt': prompt,
        if (system != null) 'system': system,
        'generationConfig': {'temperature': 0.2},
      }),
    );

    if (res.statusCode >= 400) {
      throw Exception('Proxy error: ${res.statusCode} ${res.body}');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return (json['text'] as String?) ?? '';
  }
}
