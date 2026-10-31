
import 'package:flutter/foundation.dart';

import '../models/question.dart';
import '../models/quiz_category.dart';
import '../services/quiz_api_service.dart';
import '../services/quiz_service.dart';

class QuizProvider extends ChangeNotifier {
  final QuizService _service = QuizService();
  final QuizApiService _apiService = QuizApiService();

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

  List<Question> _customQuestions = [];
  final List<Question> _apiQuestions = [];
  List<Question> _currentQuizQuestions = [];

  Map<String, int> _bestScores = {};

  bool _isLoading = false;
  String? _error;

  String? _currentCategoryId;
  int _currentQuestionIndex = 0;
  int _score = 0;

  int _requestId = 0;

  final Map<String, int> _selectedAnswers = {};

  List<QuizCategory> get categories =>
      List.unmodifiable(_categories);

  List<Question> get questions => List.unmodifiable([
    ..._apiQuestions,
    ..._customQuestions,
  ]);

  Map<String, int> get bestScores =>
      Map.unmodifiable(_bestScores);

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get score => _score;

  int get currentQuestionIndex =>
      _currentQuestionIndex;
  String? get currentCategoryId => _currentCategoryId;

  List<Question> get currentQuizQuestions =>
      List.unmodifiable(_currentQuizQuestions);

  Question? get currentQuestion {
    if (_currentQuestionIndex >=
        _currentQuizQuestions.length) {
      return null;
    }

    return _currentQuizQuestions[
    _currentQuestionIndex];
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
      _customQuestions = await _service.loadQuestions();
      _bestScores = await _service.loadBestScores();
    } catch (e) {
      _error = 'Unable to load quiz data. Please retry.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startQuiz(String categoryId) async {
    if (_isLoading) return;

    if (!_categories.any((c) => c.id == categoryId)) {
      _error = 'Invalid quiz category.';
      notifyListeners();
      return;
    }

    final requestId = ++_requestId;

    _currentCategoryId = categoryId;
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswers.clear();
    _currentQuizQuestions = [];

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedQuestions =
      await _apiService.fetchQuestions(categoryId);

      if (requestId != _requestId) return;

      _apiQuestions.removeWhere(
            (q) => q.categoryId == categoryId,
      );
      _apiQuestions.addAll(fetchedQuestions);

      final categoryCustomQuestions = _customQuestions
          .where((q) => q.categoryId == categoryId)
          .toList();

      _currentQuizQuestions = [
        ...fetchedQuestions,
        ...categoryCustomQuestions,
      ]..shuffle();

      if (_currentQuizQuestions.isEmpty) {
        _error = 'No questions available.';
      }
    } catch (e) {
      if (requestId != _requestId) return;

      // Allow saved custom questions to work offline.
      _currentQuizQuestions = _customQuestions
          .where((q) => q.categoryId == categoryId)
          .toList()
        ..shuffle();

      if (_currentQuizQuestions.isEmpty) {
        _error =
        'Could not load questions. Check your internet '
            'connection and retry.';
      }
    } finally {
      if (requestId == _requestId) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> addQuestion(Question question) async {
    if (!_categories.any(
          (c) => c.id == question.categoryId,
    )) {
      _error = 'Invalid quiz category.';
      notifyListeners();
      return false;
    }

    if (question.questionText.trim().isEmpty ||
        question.options.length < 2 ||
        question.options.any((o) => o.trim().isEmpty) ||
        question.correctAnswerIndex < 0 ||
        question.correctAnswerIndex >=
            question.options.length) {
      _error =
      'Please enter a valid question and answers.';
      notifyListeners();
      return false;
    }

    try {
      final updatedCustomQuestions = [
        ..._customQuestions,
        question,
      ];

      await _service.saveQuestions(
        updatedCustomQuestions,
      );

      _customQuestions = updatedCustomQuestions;
      _error = null;

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Could not save the question.';
      notifyListeners();
      return false;
    }
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
        _currentQuizQuestions.length) {
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
