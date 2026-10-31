
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/question_card.dart';
import 'result_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() =>
      _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool _isFinishing = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final questions = provider.currentQuizQuestions;
    final question = provider.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Questions'),
        centerTitle: true,
      ),
      body: provider.isQuizLoading
          ? _buildLoading()
          : provider.quizError != null && questions.isEmpty
          ? _buildError(context, provider)
          : questions.isEmpty
          ? _buildEmpty()
          : question == null
          ? const Center(
        child: Text('Question not found'),
      )
          : _buildQuiz(
        context,
        provider,
        questions.length,
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading quiz questions...'),
        ],
      ),
    );
  }

  Widget _buildError(
      BuildContext context,
      QuizProvider provider,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              provider.quizError ??
                  'Unable to load questions.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: provider.isQuizLoading
                  ? null
                  : () {
                final categoryId =
                    provider.currentCategoryId;

                if (categoryId != null) {
                  provider.startQuiz(categoryId);
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No questions available in this category.\n'
              'Add custom questions to start.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildQuiz(
      BuildContext context,
      QuizProvider provider,
      int totalQuestions,
      ) {
    final question = provider.currentQuestion!;

    final selectedAnswer =
    provider.selectedAnswer(question.id);

    final isLastQuestion =
        provider.currentQuestionIndex ==
            totalQuestions - 1;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Question '
                      '${provider.currentQuestionIndex + 1} '
                      'of $totalQuestions',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value:
                  (provider.currentQuestionIndex + 1) /
                      totalQuestions,
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: QuestionCard(
                question: question,
                selectedAnswerIndex: selectedAnswer,
                onAnswerSelected: provider.answerQuestion,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isFinishing
                    ? null
                    : () async {
                  if (!isLastQuestion) {
                    provider.nextQuestion();
                    return;
                  }

                  setState(() {
                    _isFinishing = true;
                  });

                  try {
                    await provider.finishQuiz();

                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ResultScreen(),
                      ),
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isFinishing = false;
                      });
                    }
                  }
                },
                child: Text(
                  _isFinishing
                      ? 'Saving Result...'
                      : isLastQuestion
                      ? 'Finish Quiz'
                      : 'Next Question',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
