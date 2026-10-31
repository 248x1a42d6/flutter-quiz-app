
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/quiz_provider.dart';
import 'screens/category_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider()..loadData(),
      child: MaterialApp(
        title: 'Quiz Master',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const CategoryScreen(),
      ),
    );
  }
}
