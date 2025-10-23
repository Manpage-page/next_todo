import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:next_todo/application/services/gemini_client.dart';

class GeminiGgaClient implements GeminiClient {
  final String apiKey;
  GeminiGgaClient(this.apiKey);

  @override
  Future<String> generate(
    String prompt, {
    String model = 'gemini-2.5-flash',
    String? system,
  }) async {
    final m = GenerativeModel(model: model, apiKey: apiKey);
    final res = await m.generateContent([Content.text(prompt)]);
    return res.text ?? '';
  }
}
