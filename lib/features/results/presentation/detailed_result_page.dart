import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../widgets/app_bar.dart';
import '../../../core/presentation/gradient_background.dart';
import '../../questionnaire/domain/question.dart';
import '../domain/questionnaire_result.dart';


class DetailedResultPage extends StatelessWidget {
  const DetailedResultPage({super.key, required this.result});

  static const String routeName = '/detailedResult';

  final QuestionnaireResult result;
  
  @override
  Widget build(BuildContext context) {
    final questionsById = {
      for (final q in kQuestions) q.id: q,
    };

    final entries = result.answers.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));

    final formatter = DateFormat.yMMMd().add_jm();

    return Scaffold(
      appBar: const GradientAppBar(title: 'நெற்றிக்கண்'),

      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 460,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Text(
                          'Here is the detailed history of your responses:',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: [
                                      Color(0xFF240090),
                                      Color(0xFF6A00FF),
                                    ],
                                  ).createShader(const Rect.fromLTWH(0, 0, 300, 20)), // Adjust width & height
                              ),
                        ),

                        Text(
                          'Score: ${result.score.toStringAsFixed(1)} (${result.riskLevel})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Date: ${formatter.format(result.createdAt.toLocal())}',
                        ),
                        const SizedBox(height: 24),

                        // New Title for History
                     
                        const SizedBox(height: 12),
                      
                        const SizedBox(height: 24),

                        Text(
                          'Answers',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        for (final entry in entries) ...[
                          _AnswerRow(
                            questionText: questionsById[entry.key]?.text ??
                                'Question ${entry.key}',
                            answer: entry.value,
                          ),
                          const Divider(),
                        ],
                      ],
                    ),

                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  const _AnswerRow({
    required this.questionText,
    required this.answer,
  });

  final String questionText;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Answer: $answer',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
