
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import 'question_screen.dart';
import 'add_question_screen.dart';
import '../theme/app_theme.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const List<IconData> categoryIcons = [
    Icons.public,
    Icons.science,
    Icons.calculate,
    Icons.account_balance,
  ];

  static const List<Color> categoryColors = [
    Color(0xFF6C63FF),
    Color(0xFF00A896),
    Color(0xFFFF9800),
    Color(0xFFEC4899),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: const Text(
          'Quiz Master',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F3FF),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: provider.loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : _buildHome(context, provider),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Question'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddQuestionScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHome(
      BuildContext context,
      QuizProvider provider,
      ) {
    final categories = provider.categories;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6C63FF),
                Color(0xFF9C71F7),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 36,
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to Quiz Master!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Choose a category and challenge yourself.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Text(
          'Explore Categories',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        if (categories.isEmpty)
          const Center(
            child: Text('No categories available'),
          ),

        ...List.generate(categories.length, (index) {
          final category = categories[index];

          final icon = categoryIcons[
          index % categoryIcons.length];

          final color = AppTheme.categoryColor(index);

          final questionCount = provider.questions
              .where((q) => q.categoryId == category.id)
              .length;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            child: Material(
              color: Colors.white,
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  provider.startQuiz(category.id);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuestionScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '$questionCount Questions',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: color,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
