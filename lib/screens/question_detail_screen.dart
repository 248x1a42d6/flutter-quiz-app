
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/question.dart';
import '../providers/quiz_provider.dart';

class QuestionDetailScreen extends StatelessWidget {
  const QuestionDetailScreen({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();

    final category = provider.categories.where(
          (item) => item.id == question.categoryId,
    );

    final categoryName = category.isNotEmpty
        ? category.first.name
        : question.categoryId;

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categoryName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const Divider(height: 32),
                    Text(
                      'Question',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.questionText,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Answer Options',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8),

            ...List.generate(question.options.length, (index) {
              final isCorrect =
                  index == question.correctAnswerIndex;

              return Card(
                child: ListTile(
                  leading: Icon(
                    isCorrect
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isCorrect
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  title: Text(question.options[index]),
                  subtitle: isCorrect
                      ? const Text('Correct Answer')
                      : null,
                  trailing: Text(
                    'Option ${index + 1}',
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The correct answer is highlighted '
                            'with a check mark.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
