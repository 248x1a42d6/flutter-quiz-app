
import 'package:flutter/foundation.dart';

import '../models/question.dart';
import '../models/quiz_category.dart';
import '../services/quiz_service.dart';

class QuizProvider extends ChangeNotifier {
  final QuizService _service = QuizService();

  final List<QuizCategory> _categories = [
    const QuizCategory(
      id: 'general',
      name: 'General Knowledge',
      description: 'Test your general knowledge',
    ),
    const QuizCategory(
      id: 'science',
      name: 'Science',
      description: 'Explore science questions',
    ),
    const QuizCategory(
      id: 'math',
      name: 'Mathematics',
      description: 'Practice mathematics',
    ),
    const QuizCategory(
      id: 'history',
      name: 'History',
      description: 'Test your history knowledge',
    ),
  ];

  List<Question> _questions = [];
  Map<String, int> _bestScores = {};

  bool _isLoading = false;
  String? _error;

  String? _currentCategoryId;
  int _currentQuestionIndex = 0;
  int _score = 0;
  final Map<String, int> _selectedAnswers = {};

  List<QuizCategory> get categories =>
      List.unmodifiable(_categories);

  List<Question> get questions =>
      List.unmodifiable(_questions);

  Map<String, int> get bestScores =>
      Map.unmodifiable(_bestScores);

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get score => _score;
  int get currentQuestionIndex => _currentQuestionIndex;

  List<Question> get currentQuizQuestions {
    return _questions
        .where((q) => q.categoryId == _currentCategoryId)
        .toList();
  }

  Question? get currentQuestion {
    final list = currentQuizQuestions;

    if (_currentQuestionIndex >= list.length) {
      return null;
    }

    return list[_currentQuestionIndex];
  }

  int? selectedAnswer(String questionId) =>
      _selectedAnswers[questionId];

  int bestScore(String categoryId) =>
      _bestScores[categoryId] ?? 0;

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _questions = await _service.loadQuestions();
      _bestScores = await _service.loadBestScores();
    } catch (e) {
      _error = 'Unable to load quiz data. Please retry.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addQuestion(Question question) async {
    if (!_categories.any((c) => c.id == question.categoryId)) {
      _error = 'Invalid quiz category.';
      notifyListeners();
      return false;
    }

    if (question.questionText.trim().isEmpty ||
        question.options.length < 2 ||
        question.options.any((o) => o.trim().isEmpty) ||
        question.correctAnswerIndex < 0 ||
        question.correctAnswerIndex >= question.options.length) {
      _error = 'Please enter a valid question and answers.';
      notifyListeners();
      return false;
    }

    try {
      final updated = [..._questions, question];
      await _service.saveQuestions(updated);
      _questions = updated;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Could not save the question.';
      notifyListeners();
      return false;
    }
  }

  void startQuiz(String categoryId) {
    _currentCategoryId = categoryId;
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswers.clear();
    notifyListeners();
  }

  void answerQuestion(int answerIndex) {
    final question = currentQuestion;

    if (question == null ||
        answerIndex < 0 ||
        answerIndex >= question.options.length ||
        _selectedAnswers.containsKey(question.id)) {
      return;
    }

    _selectedAnswers[question.id] = answerIndex;

    if (question.isCorrect(answerIndex)) {
      _score++;
    }

    notifyListeners();
  }

  bool nextQuestion() {
    if (_currentQuestionIndex + 1 >=
        currentQuizQuestions.length) {
      return false;
    }

    _currentQuestionIndex++;
    notifyListeners();
    return true;
  }

  Future<void> finishQuiz() async {
    if (_currentCategoryId == null) return;

    try {
      await _service.saveBestScore(
        _currentCategoryId!,
        _score,
      );

      _bestScores = await _service.loadBestScores();
      _error = null;
    } catch (e) {
      _error = 'Unable to save your best score.';
    }

    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
