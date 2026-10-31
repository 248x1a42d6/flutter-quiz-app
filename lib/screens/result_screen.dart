
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import 'question_screen.dart';

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

    final percentage =
    total == 0 ? 0.0 : (correct / total) * 100;

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Icon(
                Icons.emoji_events_rounded,
                size: 68,
                color: colors.primary,
              ),
              const SizedBox(height: 14),
              Text(
                'Quiz Completed!',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Score: $correct / $total',
                style:
                Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 28),

              // Results pie chart
              SizedBox(
                width: 220,
                height: 220,
                child: CustomPaint(
                  painter: QuizPieChartPainter(
                    correct: correct,
                    wrong: wrong,
                    unanswered: unanswered,
                    correctColor: colors.primary,
                    wrongColor: colors.error,
                    unansweredColor: colors.tertiary,
                    emptyColor: colors.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Correct'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _resultRow(
                context,
                Icons.check_circle_outline,
                'Correct Answers',
                correct,
                colors.primary,
              ),
              _resultRow(
                context,
                Icons.cancel_outlined,
                'Wrong Answers',
                wrong,
                colors.error,
              ),
              _resultRow(
                context,
                Icons.remove_circle_outline,
                'Not Attempted',
                unanswered,
                colors.tertiary,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: provider.isLoading ||
                      questions.isEmpty
                      ? null
                      : () {
                    final categoryId =
                        provider.currentCategoryId;

                    if (categoryId == null) return;

                    provider.startQuiz(categoryId);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const QuestionScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Play Again'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
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
    );
  }

  Widget _resultRow(
      BuildContext context,
      IconData icon,
      String label,
      int value,
      Color color,
      ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label),
        trailing: Text(
          '$value',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class QuizPieChartPainter extends CustomPainter {
  final int correct;
  final int wrong;
  final int unanswered;

  final Color correctColor;
  final Color wrongColor;
  final Color unansweredColor;
  final Color emptyColor;

  QuizPieChartPainter({
    required this.correct,
    required this.wrong,
    required this.unanswered,
    required this.correctColor,
    required this.wrongColor,
    required this.unansweredColor,
    required this.emptyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = correct + wrong + unanswered;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(size.width, size.height) / 2 - 14;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 32
      ..strokeCap = StrokeCap.butt;

    if (total == 0) {
      paint.color = emptyColor;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    var startAngle = -math.pi / 2;

    final segments = [
      (correct, correctColor),
      (wrong, wrongColor),
      (unanswered, unansweredColor),
    ];

    for (final segment in segments) {
      if (segment.$1 == 0) continue;

      final sweepAngle =
          (segment.$1 / total) * 2 * math.pi;

      paint.color = segment.$2;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(
      covariant QuizPieChartPainter oldDelegate,
      ) {
    return oldDelegate.correct != correct ||
        oldDelegate.wrong != wrong ||
        oldDelegate.unanswered != unanswered ||
        oldDelegate.correctColor != correctColor ||
        oldDelegate.wrongColor != wrongColor ||
        oldDelegate.unansweredColor != unansweredColor ||
        oldDelegate.emptyColor != emptyColor;
  }
}
