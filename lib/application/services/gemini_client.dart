abstract class GeminiClient {
  Future<String> generate(
    String prompt, {
    String model = 'gemini-1.5-flash',
    String? system,
  });
}
