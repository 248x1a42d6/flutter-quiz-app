
import 'package:flutter/material.dart';

import '../models/question.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int? selectedAnswerIndex;
  final ValueChanged<int> onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswerIndex,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAnswered = selectedAnswerIndex != null;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            ...List.generate(question.options.length, (index) {
              final isSelected = selectedAnswerIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OutlinedButton(
                  onPressed: hasAnswered
                      ? null
                      : () => onAnswerSelected(index),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: isSelected
                        ? theme.colorScheme.primaryContainer
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(question.options[index]),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_outline),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
