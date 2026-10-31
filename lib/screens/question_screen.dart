
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/question_card.dart';
import 'result_screen.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : questions.isEmpty
          ? const Center(
        child: Text(
          'No questions available in this category.\n'
              'Add custom questions to start.',
          textAlign: TextAlign.center,
        ),
      )
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

  Widget _buildQuiz(
      BuildContext context,
      QuizProvider provider,
      int totalQuestions,
      ) {
    final question = provider.currentQuestion!;

    final selectedAnswer = provider.selectedAnswer(
      question.id,
    );

    final isLastQuestion =
        provider.currentQuestionIndex == totalQuestions - 1;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Question ${provider.currentQuestionIndex + 1} '
                      'of $totalQuestions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (provider.currentQuestionIndex + 1) /
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
                onPressed: () async {
                  if (isLastQuestion) {
                    await provider.finishQuiz();

                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResultScreen(),
                      ),
                    );
                  } else {
                    provider.nextQuestion();
                  }
                },
                child: Text(
                  isLastQuestion ? 'Finish Quiz' : 'Next Question',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
