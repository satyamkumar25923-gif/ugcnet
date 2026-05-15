import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exam_provider.dart';
import '../../core/theme.dart';

class QuestionPalette extends StatelessWidget {
  const QuestionPalette({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Question Palette',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            
            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildLegendItem(AppTheme.successGreen, 'Answered'),
                  _buildLegendItem(Colors.grey[300]!, 'Unanswered'),
                  _buildLegendItem(Colors.orange, 'Review'),
                ],
              ),
            ),
            const Divider(),

            Expanded(
              child: Consumer<ExamProvider>(
                builder: (context, provider, child) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: provider.questions.length,
                    itemBuilder: (context, index) {
                      final status = provider.questionStatuses[index];
                      Color bgColor;
                      Color textColor = Colors.black;

                      switch (status) {
                        case QuestionStatus.answered:
                          bgColor = AppTheme.successGreen;
                          textColor = Colors.white;
                          break;
                        case QuestionStatus.markedForReview:
                          bgColor = Colors.orange;
                          textColor = Colors.white;
                          break;
                        default:
                          bgColor = Colors.grey[200]!;
                      }

                      if (provider.currentIndex == index) {
                        return InkWell(
                          onTap: () {
                            provider.jumpToQuestion(index);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              border: Border.all(color: AppTheme.primaryBlue, width: 3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }

                      return InkWell(
                        onTap: () {
                          provider.jumpToQuestion(index);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
