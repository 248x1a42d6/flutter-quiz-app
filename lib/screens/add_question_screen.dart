
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/question.dart';
import '../providers/quiz_provider.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() =>
      _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _questionController = TextEditingController();

  final List<TextEditingController> _optionControllers =
  List.generate(
    4,
        (_) => TextEditingController(),
  );

  String? _selectedCategoryId;

  // No correct answer is selected by default.
  int? _correctAnswerIndex;

  bool _isSaving = false;

  @override
  void dispose() {
    _questionController.dispose();

    for (final controller in _optionControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _saveQuestion() async {
    if (_isSaving) return;

    // Validate the category, question and all four options.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
        ),
      );
      return;
    }

    // Require the user to select a correct answer.
    if (_correctAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the correct answer'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final question = Question(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      categoryId: _selectedCategoryId!,
      questionText: _questionController.text.trim(),
      options: _optionControllers
          .map((controller) => controller.text.trim())
          .toList(),
      correctAnswerIndex: _correctAnswerIndex!,
    );

    final provider = context.read<QuizProvider>();

    final bool saved = await provider.addQuestion(question);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question saved successfully!'),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ?? 'Unable to save question',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        context.watch<QuizProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Custom Question'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Quiz Category',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }

                  if (!categories.any(
                        (category) => category.id == value,
                  )) {
                    return 'Please select a valid category';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  hintText: 'Enter your quiz question',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 300,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: TextFormField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Option ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    maxLength: 150,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter option ${index + 1}';
                      }
                      return null;
                    },
                  ),
                );
              }),

              const SizedBox(height: 8),

              Text(
                'Select the correct answer',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 8),

              RadioGroup<int>(
                groupValue: _correctAnswerIndex,
                onChanged: (int? value) {
                  if (!_isSaving && value != null) {
                    setState(() {
                      _correctAnswerIndex = value;
                    });
                  }
                },
                child: Column(
                  children: List.generate(4, (index) {
                    return RadioListTile<int>(
                      title: Text('Option ${index + 1}'),
                      value: index,
                      enabled: !_isSaving,
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed:
                  _isSaving ? null : _saveQuestion,
                  icon: _isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _isSaving
                        ? 'Saving...'
                        : 'Save Question',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
