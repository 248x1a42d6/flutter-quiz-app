
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/question.dart';
import '../providers/quiz_provider.dart';

class ManageQuestionsScreen extends StatelessWidget {
  const ManageQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final questions = provider.customQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Questions'),
        centerTitle: true,
      ),
      body: questions.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No custom questions added yet.',
            textAlign: TextAlign.center,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];

          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.quiz_outlined,
              ),
              title: Text(question.questionText),
              subtitle: Text(
                'Category: ${_categoryName(
                  provider,
                  question.categoryId,
                )}',
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context)
                      .colorScheme
                      .error,
                ),
                tooltip: 'Delete question',
                onPressed: () => _confirmDelete(
                  context,
                  provider,
                  question,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _categoryName(
      QuizProvider provider,
      String categoryId,
      ) {
    for (final category in provider.categories) {
      if (category.id == categoryId) {
        return category.name;
      }
    }

    return categoryId;
  }

  Future<void> _confirmDelete(
      BuildContext context,
      QuizProvider provider,
      Question question,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Question?'),
          content: Text(
            'Are you sure you want to delete '
                '"${question.questionText}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final deleted = await provider.deleteQuestion(
      question.id,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deleted
              ? 'Question deleted successfully.'
              : provider.error ??
              'Unable to delete question.',
        ),
      ),
    );
  }
}
