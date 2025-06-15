import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reviseitai/core/constants/app_constants.dart';

class GeminiService {
  final String apiKey;
  final String apiEndpoint;
  
  GeminiService({
    this.apiKey = AppConstants.geminiApiKey,
    this.apiEndpoint = AppConstants.geminiApiEndpoint,
  });
  
  Future<Map<String, dynamic>> generateContent(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$apiEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{
              'text': prompt
            }]
          }]
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }
  
  Future<String> generateSummary(String text) async {
    final prompt = 'Summarize the following text in a concise way: $text';
    final response = await generateContent(prompt);
    return _extractTextFromResponse(response);
  }
  
  Future<List<Map<String, dynamic>>> generateFlashcards(String text) async {
    final prompt = 'Create a set of 5-10 flashcards with questions and answers based on this text: $text';
    final response = await generateContent(prompt);
    final content = _extractTextFromResponse(response);
    
    // Parse the response into flashcards
    // This is a simplified implementation
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
      flashcards.add({
        'question': currentQuestion,
        'answer': currentAnswer,
      });
    }
    
    return flashcards;
  }
  
  Future<Map<String, dynamic>> generateMindMap(String text) async {
    final prompt = 'Create a mind map in JSON format with nodes and connections based on this text: $text. The JSON should have a "root" node and "children" nodes with "connections" between them.';
    final response = await generateContent(prompt);
    final content = _extractTextFromResponse(response);
    
    // Extract JSON from the response
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
  
  String _extractTextFromResponse(Map<String, dynamic> response) {
    try {
      return response['candidates'][0]['content']['parts'][0]['text'];
    } catch (e) {
      throw Exception('Failed to extract text from response: $e');
    }
  }
}