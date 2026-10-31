
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final questions = provider.currentQuizQuestions;

    final total = questions.length;
    final correct = provider.score;

    final attempted = questions.where((question) {
      return provider.selectedAnswer(question.id) != null;
    }).length;

    final wrong = attempted - correct;
    final unanswered = total - attempted;

    final percentage = total == 0
        ? 0.0
        : (correct / total) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),

                Text(
                  'Quiz Completed!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),

                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 12),

                Text(
                  'Score: $correct / $total',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 28),

                _resultRow(
                  context,
                  Icons.check_circle_outline,
                  'Correct Answers',
                  correct,
                ),
                _resultRow(
                  context,
                  Icons.cancel_outlined,
                  'Wrong Answers',
                  wrong,
                ),
                _resultRow(
                  context,
                  Icons.remove_circle_outline,
                  'Not Attempted',
                  unanswered,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil(
                            (route) => route.isFirst,
                      );
                    },
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Back to Categories'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultRow(
      BuildContext context,
      IconData icon,
      String label,
      int value,
      ) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(label),
        trailing: Text(
          '$value',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
