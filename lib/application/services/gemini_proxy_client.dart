import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:next_todo/application/services/gemini_client.dart';

class GeminiProxyClient implements GeminiClient {
  final String endpoint; // ex) https://gemini-proxy.xxx.workers.dev
  final String? appToken; // 任意

  const GeminiProxyClient(this.endpoint, {this.appToken});

  @override
  Future<String> generate(
    String prompt, {
    String model = 'gemini-1.5-flash',
    String? system,
  }) async {
    final res = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        if (appToken != null && appToken!.isNotEmpty) 'X-App-Token': appToken!,
      },
      body: jsonEncode({
        'prompt': prompt,
        'model': model,
        if (system != null) 'system': system,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('Gemini proxy error: ${res.statusCode} ${res.body}');
    }
    final m = jsonDecode(res.body) as Map<String, dynamic>;
    final cand = (m['candidates'] as List?)?.first;
    final parts = (cand?['content']?['parts'] as List?) ?? const [];
    return (parts.isNotEmpty ? (parts.first['text'] as String? ?? '') : '')
        .trim();
  }
}
