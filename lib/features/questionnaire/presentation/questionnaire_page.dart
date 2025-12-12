import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../animations/animation_utils.dart';
import '../../../assets/assets_paths.dart';
import '../../../core/presentation/gradient_background.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/morphic/morphic_button.dart';
import '../../../widgets/safe_lottie.dart';
import '../../results/data/results_repository.dart';
import '../../results/presentation/result_page.dart';
import '../domain/question.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  static const String routeName = '/questionnaire';

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final Map<String, String> _answers = {};
  bool _isSubmitting = false;

  void _setAnswer(String questionId, String value) {
    setState(() {
      _answers[questionId] = value;
    });
  }

  Future<void> _submit() async {
    if (_answers.length != kQuestions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before submitting.'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to submit results.'),
        ),
      );
      return;
    }

    double score = 0;
    for (final question in kQuestions) {
      final answer = _answers[question.id];
      if (answer == 'Yes') {
        score += 1;
      } else if (answer == 'Sometimes') {
        score += 0.5;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await ResultsRepository.instance.createAndSaveResult(
        uid: user.uid,
        score: score,
        answers: Map<String, String>.from(_answers),
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        ResultPage.routeName,
        arguments: result,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save result. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = kQuestions.length;
    final answered = _answers.length;
    final progress = total == 0 ? 0.0 : answered / total;

    return Scaffold(
    appBar: const GradientAppBar(title: 'நெற்றிக்கண்'), 

      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const FadeSlide(
                  offset: Offset(0, 16),
                  child: SafeLottie(
                    asset: AppIcons.appLogo,
                    height: 110,
                  ),
                ),
                const SizedBox(height: 8),
                FadeSlide(
                  delay: const Duration(milliseconds: 80),
                    child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF8F94FB),
                        Color(0xFF4E54C8),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: Text(
                      'Screening Assessment',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white, // needed for gradient effect
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ),
                const SizedBox(height: 6),
                FadeSlide(
                  delay: const Duration(milliseconds: 140),
                  child: Text(
                    'Please answer each question based on your child\'s typical behaviour.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                FadeSlide(
                  delay: const Duration(milliseconds: 160),
                  child: AnimatedProgressBar(progress: progress),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: kQuestions.length,
                    itemBuilder: (context, index) {
                      final question = kQuestions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FadeSlide(
                          delay: Duration(milliseconds: 120 + index * 20),
                          offset: const Offset(0, 18),
                          child: _QuestionCard(
                            question: question,
                            selectedValue: _answers[question.id],
                            onChanged:
                                (value) => _setAnswer(question.id, value),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FadeSlide(
                  delay: const Duration(milliseconds: 220),
                  child: SizedBox(
                    width: double.infinity,
                    child: MorphicButton(
                      onPressed: _isSubmitting ? () {} : _submit,
                      child:
                          _isSubmitting
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text('Submit questionnaire'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selectedValue,
    required this.onChanged,
  });

  final Question question;
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (question.taText != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    question.taText!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              title: const Text('Yes'),
              value: 'Yes',
              groupValue: selectedValue,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
            // RadioListTile<String>(
            //   title: const Text('Sometimes'),
            //   value: 'Sometimes',
            //   groupValue: selectedValue,
            //   onChanged: (value) {
            //     if (value != null) {
            //       onChanged(value);
            //     }
            //   },
            // ),
            RadioListTile<String>(
              title: const Text('No'),
              value: 'No',
              groupValue: selectedValue,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
