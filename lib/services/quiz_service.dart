
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';

class QuizService {
  static const String _questionsKey = 'custom_quiz_questions';
  static const String _bestScoresKey = 'quiz_best_scores';

  // Save custom questions to the phone.
  Future<void> saveQuestions(List<Question> questions) async {
    final prefs = await SharedPreferences.getInstance();

    final encodedQuestions = jsonEncode(
      questions.map((question) => question.toJson()).toList(),
    );

    final success = await prefs.setString(
      _questionsKey,
      encodedQuestions,
    );

    if (!success) {
      throw Exception('Unable to save quiz questions');
    }
  }

  // Load saved custom questions.
  Future<List<Question>> loadQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_questionsKey);

    if (savedData == null) {
      return [];
    }

    final decodedData = jsonDecode(savedData) as List<dynamic>;

    return decodedData.map((item) {
      return Question.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // Save the best score for a category.
  Future<void> saveBestScore(
      String categoryId,
      int score,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await loadBestScores();

    if (score > (scores[categoryId] ?? 0)) {
      scores[categoryId] = score;

      final success = await prefs.setString(
        _bestScoresKey,
        jsonEncode(scores),
      );

      if (!success) {
        throw Exception('Unable to save best score');
      }
    }
  }

  // Load all saved best scores.
  Future<Map<String, int>> loadBestScores() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_bestScoresKey);

    if (savedData == null) {
      return {};
    }

    final decodedData = jsonDecode(savedData);

    return Map<String, int>.from(decodedData as Map);
  }
}
