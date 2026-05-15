import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exam_provider.dart';
import '../../core/theme.dart';
import '../widgets/question_palette.dart';

class MockTestScreen extends StatelessWidget {
  const MockTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamProvider>(
      builder: (context, examProvider, child) {
        if (examProvider.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentQuestion = examProvider.questions[examProvider.currentIndex];

        return Scaffold(
          appBar: AppBar(
            title: const Text('UGC NET Mock Test'),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.softBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: AppTheme.primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      examProvider.formattedTime,
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          drawer: const QuestionPalette(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${examProvider.currentIndex + 1}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      '${currentQuestion.paperType} | ${currentQuestion.subject}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Divider(height: 32),

                // Question Text
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentQuestion.question,
                          style: const TextStyle(fontSize: 20, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        ...currentQuestion.options.map((option) {
                          bool isSelected = examProvider.userAnswers[examProvider.currentIndex] == option;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onTap: () => examProvider.selectOption(option),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.softBlue : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? AppTheme.primaryBlue : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: option,
                                      groupValue: examProvider.userAnswers[examProvider.currentIndex],
                                      onChanged: (value) {
                                        if (value != null) examProvider.selectOption(value);
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: examProvider.currentIndex > 0 ? examProvider.previousQuestion : null,
                        child: const Text('Previous'),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: examProvider.markForReview,
                            child: const Text('Mark for Review'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (examProvider.currentIndex < examProvider.questions.length - 1) {
                                examProvider.nextQuestion();
                              } else {
                                // Last question
                                _showSubmitDialog(context, examProvider);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(120, 48),
                            ),
                            child: Text(examProvider.currentIndex < examProvider.questions.length - 1 ? 'Save & Next' : 'Submit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSubmitDialog(BuildContext context, ExamProvider examProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Test?'),
        content: Text('You have answered ${examProvider.userAnswers.length} out of ${examProvider.questions.length} questions. Are you sure you want to submit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              examProvider.submitTest();
              Navigator.pop(context);
              // Navigate to results
              Navigator.pushReplacementNamed(context, '/results');
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
