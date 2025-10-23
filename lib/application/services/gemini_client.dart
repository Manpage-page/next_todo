abstract class GeminiClient {
  Future<String> generate(
    String prompt, {
    String model = 'gemini-2.5-flash',
    String? system,
  });
}
