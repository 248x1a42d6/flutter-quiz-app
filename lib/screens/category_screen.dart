
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import 'question_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Categories'),
        centerTitle: true,
      ),
      body: _buildBody(context, quizProvider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add Question screen navigation
          // will be connected during integration.
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Question'),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      QuizProvider provider,
      ) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.error!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: provider.loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final categories = provider.categories;

    if (categories.isEmpty) {
      return const Center(
        child: Text('No quiz categories available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return Card(
          child: ListTile(
            leading: const Icon(Icons.quiz_outlined),
            title: Text(category.name),
            subtitle: Text(category.description),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              provider.startQuiz(category.id);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuestionScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
