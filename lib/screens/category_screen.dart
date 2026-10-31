
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import 'add_question_screen.dart';
import 'manage_questions_screen.dart';
import 'question_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const List<IconData> categoryIcons = [
    Icons.public,
    Icons.science,
    Icons.calculate,
    Icons.account_balance,
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Quiz Master',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.background,
        actions: [
          IconButton(
            tooltip: 'Manage Questions',
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const ManageQuestionsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // Loading, error, empty and populated states.
      body: provider.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : provider.error != null
          ? _buildError(context, provider)
          : _buildHome(context, provider),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: colors.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Question'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddQuestionScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(
      BuildContext context,
      QuizProvider provider,
      ) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colors.error,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              provider.error ??
                  'Unable to load quiz data.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: provider.loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome(
      BuildContext context,
      QuizProvider provider,
      ) {
    final categories = provider.categories;
    final colors = Theme.of(context).colorScheme;

    if (categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 60,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              const Text(
                'No quiz categories available.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        100,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary,
                AppTheme.primary.withValues(alpha: 0.75),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.auto_awesome,
                color: colors.onPrimary,
                size: 36,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to Quiz Master!',
                style: TextStyle(
                  color: colors.onPrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a category and challenge yourself.',
                style: TextStyle(
                  color: colors.onPrimary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Text(
          'Explore Categories',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        ...List.generate(categories.length, (index) {
          final category = categories[index];

          final icon = categoryIcons[
          index % categoryIcons.length];

          final color = AppTheme.categoryColor(index);

          // Retrieve the saved best score for this category.
          final bestScore =
          provider.bestScore(category.id);

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            child: Material(
              color: colors.surface,
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),

                onTap: () {
                  if (provider.isLoading ||
                      provider.isQuizLoading) {
                    return;
                  }

                  provider.startQuiz(category.id);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const QuestionScreen(),
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
                          color: color.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius:
                          BorderRadius.circular(16),
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
                              category.description,
                              style: TextStyle(
                                color:
                                colors.onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // GP requirement:
                            // Display the saved best score.
                            Row(
                              children: [
                                Icon(
                                  Icons.emoji_events_outlined,
                                  size: 18,
                                  color: color,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Best Score: $bestScore',
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 13,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
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
