import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reviseitai/core/constants/app_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String apiKey;
  final String apiEndpoint;

  GeminiService({
    String? apiKey,
    String? apiEndpoint,
  }) : this.apiKey = apiKey ?? _getApiKey(),
       this.apiEndpoint = apiEndpoint ?? AppConstants.geminiApiEndpoint;

  static String _getApiKey() {
    try {
      // Try to get API key from environment variables
      final envKey = dotenv.env['GEMINI_API_KEY'];
      if (envKey != null && envKey.isNotEmpty) {
        return envKey;
      }
    } catch (e) {
      // If dotenv is not initialized or fails, continue to fallback
      print('Warning: Could not load API key from environment: $e');
    }
    
    // Fallback to constants
    return AppConstants.geminiApiKey;
  }

  Future<Map<String, dynamic>> generateContent(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$apiEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] != null) {
          throw Exception('API Error: ${responseData['error']['message']}');
        }
        return responseData;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Failed to generate content: ${errorData['error']['message'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from API');
      }
      throw Exception('API request failed: $e');
    }
  }

  Future<String> generateSummary(String text) async {
    final prompt = 'Summarize the following text in a concise way: $text';
    final response = await generateContent(prompt);
    return extractTextFromResponse(response);
  }

  Future<List<Map<String, dynamic>>> generateFlashcards(String text) async {
    final prompt =
        'Create a set of 5-10 flashcards with questions and answers based on this text: $text';
    final response = await generateContent(prompt);
    final content = extractTextFromResponse(response);

    // Parse the response into flashcards
    final List<Map<String, dynamic>> flashcards = [];
    final lines = content.split('\n');

    String currentQuestion = '';
    String currentAnswer = '';

    for (final line in lines) {
      if (line.startsWith('Q:')) {
        if (currentQuestion.isNotEmpty && currentAnswer.isNotEmpty) {
          flashcards.add({
            'question': currentQuestion,
            'answer': currentAnswer,
          });
        }
        currentQuestion = line.substring(2).trim();
        currentAnswer = '';
      } else if (line.startsWith('A:')) {
        currentAnswer = line.substring(2).trim();
      }
    }

    if (currentQuestion.isNotEmpty && currentAnswer.isNotEmpty) {
      flashcards.add({'question': currentQuestion, 'answer': currentAnswer});
    }

    return flashcards;
  }

  Future<Map<String, dynamic>> generateMindMap(String text) async {
    final prompt =
        'Create a mind map in JSON format with nodes and connections based on this text: $text. The JSON should have a "root" node and "children" nodes with "connections" between them.';
    final response = await generateContent(prompt);
    final content = extractTextFromResponse(response);

    try {
      // Find JSON in the response
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}') + 1;
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        final jsonStr = content.substring(jsonStart, jsonEnd);
        return jsonDecode(jsonStr);
      } else {
        throw Exception('Could not extract valid JSON from response');
      }
    } catch (e) {
      throw Exception('Failed to parse mind map JSON: $e');
    }
  }

  Future<List<Map<String, dynamic>>> generateRevisionSchedule(String text) async {
    final prompt =
        'Create a spaced repetition schedule for learning the following content: $text. ' +
        'The schedule should follow the spacing intervals of [1, 3, 7, 14, 30] days and include ' +
        'specific topics to focus on for each revision session. Return the result as a JSON array ' +
        'with objects containing "day" (int), "date" (string), "topics" (array of strings), and "duration" (string).'
    ;
    final response = await generateContent(prompt);
    final content = extractTextFromResponse(response);

    try {
      // Find JSON in the response
      final jsonStart = content.indexOf('[');
      final jsonEnd = content.lastIndexOf(']') + 1;
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        final jsonStr = content.substring(jsonStart, jsonEnd);
        return List<Map<String, dynamic>>.from(jsonDecode(jsonStr));
      } else {
        throw Exception('Could not extract valid JSON from response');
      }
    } catch (e) {
      throw Exception('Failed to parse revision schedule JSON: $e');
    }
  }

  String extractTextFromResponse(Map<String, dynamic> response) {
    try {
      if (response['candidates'] == null || response['candidates'].isEmpty) {
        throw Exception('No response from the model');
      }

      final candidate = response['candidates'][0];
      if (candidate['content'] == null ||
          candidate['content']['parts'] == null ||
          candidate['content']['parts'].isEmpty) {
        throw Exception('Invalid response format');
      }

      return candidate['content']['parts'][0]['text'];
    } catch (e) {
      throw Exception('Failed to extract text from response: $e');
    }
  }
}
