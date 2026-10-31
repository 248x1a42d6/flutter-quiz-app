
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:quiz_app/providers/quiz_provider.dart';
import 'package:quiz_app/screens/category_screen.dart';

void main() {
  testWidgets('Quiz categories display correctly', (
      WidgetTester tester,
      ) async {
    final provider = QuizProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<QuizProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: CategoryScreen(),
        ),
      ),
    );

    expect(
      find.byType(CategoryScreen),
      findsOneWidget,
    );

    expect(
      find.text('General Knowledge'),
      findsOneWidget,
    );

    expect(
      find.text('Science'),
      findsOneWidget,
    );

    expect(
      find.text('Mathematics'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.text('History'),
      150,
      scrollable: find.byType(Scrollable).first,
    );

    expect(
      find.text('History'),
      findsOneWidget,
    );
  });
}
