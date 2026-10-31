
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/question.dart';

class QuizApiService {
  static const Map<String, int> categoryIds = {
    'general': 9,
    'science': 17,
    'math': 19,
    'history': 23,
  };

  String? _sessionToken;
  DateTime? _lastRequestTime;

  Future<http.Response> _get(Uri url) async {
    if (_lastRequestTime != null) {
      final elapsed =
      DateTime.now().difference(_lastRequestTime!);

      const minimumInterval = Duration(seconds: 6);

      if (elapsed < minimumInterval) {
        await Future.delayed(
          minimumInterval - elapsed,
        );
      }
    }

    _lastRequestTime = DateTime.now();

    return http
        .get(url)
        .timeout(const Duration(seconds: 15));
  }

  Future<void> _createSession() async {
    if (_sessionToken != null) return;

    final url = Uri.https(
      'opentdb.com',
      '/api_token.php',
      {'command': 'request'},
    );

    final response = await _get(url);

    if (response.statusCode != 200) {
      throw Exception('Unable to create quiz session.');
    }

    final data =
    jsonDecode(response.body) as Map<String, dynamic>;

    if (data['response_code'] != 0 ||
        data['token'] is! String) {
      throw Exception('Unable to create quiz session.');
    }

    _sessionToken = data['token'] as String;
  }

  Future<List<Question>> fetchQuestions(
      String categoryId,
      ) async {
    final apiCategory = categoryIds[categoryId];

    if (apiCategory == null) {
      throw Exception('Invalid quiz category.');
    }

    await _createSession();

    final url = Uri.https(
      'opentdb.com',
      '/api.php',
      {
        'amount': '10',
        'category': apiCategory.toString(),
        'type': 'multiple',
        'encode': 'url3986',
        'token': _sessionToken!,
      },
    );

    final response = await _get(url);

    if (response.statusCode != 200) {
      throw Exception('Unable to load questions.');
    }

    final data =
    jsonDecode(response.body) as Map<String, dynamic>;

    final responseCode = data['response_code'];

    if (responseCode == 3) {
      _sessionToken = null;
      throw Exception(
        'Quiz session expired. Please retry.',
      );
    }

    if (responseCode == 4) {
      throw Exception(
        'No unused questions remain in this category.',
      );
    }

    if (responseCode == 5) {
      throw Exception(
        'Too many requests. Please retry shortly.',
      );
    }

    if (responseCode != 0) {
      throw Exception(
        'Questions are currently unavailable.',
      );
    }

    final results = data['results'] as List<dynamic>;

    return List.generate(results.length, (index) {
      final item =
      results[index] as Map<String, dynamic>;

      final correctAnswer = Uri.decodeComponent(
        item['correct_answer'] as String,
      );

      final incorrectAnswers =
      (item['incorrect_answers'] as List<dynamic>)
          .map(
            (answer) => Uri.decodeComponent(
          answer as String,
        ),
      )
          .toList();

      final options = [
        ...incorrectAnswers,
        correctAnswer,
      ]..shuffle();

      return Question(
        id: 'api_${categoryId}_'
            '${DateTime.now().microsecondsSinceEpoch}_$index',
        categoryId: categoryId,
        questionText: Uri.decodeComponent(
          item['question'] as String,
        ),
        options: options,
        correctAnswerIndex:
        options.indexOf(correctAnswer),
      );
    });
  }
}
