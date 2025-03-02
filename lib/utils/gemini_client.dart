import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiClient {
  GeminiClient({
    required this.model,
  });

  final GenerativeModel model;

  Future generateContentFromText({
    required String prompt,
  }) async {
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text;
  }
}
