import 'package:flutter/material.dart';

import '../../../animations/animation_utils.dart';
import '../../../assets/assets_paths.dart';
import '../../../core/presentation/gradient_background.dart';
import '../../../widgets/morphic/glass_card.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/morphic/morphic_button.dart';
import '../../../widgets/safe_lottie.dart';
import '../../home/presentation/home_page.dart';
import '../domain/questionnaire_result.dart';
import 'results_history_page.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.result});

  static const String routeName = '/result';

  final QuestionnaireResult result;

 Color _statusColor(String riskLevel) {
  switch (riskLevel) {
    case 'Low':
      return Colors.teal; // passed
    case 'Medium':
      return Colors.amberAccent.shade700; // watch
    case 'High':
    default:
      return Colors.deepPurple; // consult doctor
  }
}


String _statusLabel(String riskLevel) {
  switch (riskLevel) {
    case 'Low':
      return 'Congratulations! Your child has successfully passed the screening.';
    case 'Medium':
      return 'Your child shows some areas to keep an eye on. You may continue to observe and support development.';
    case 'High':
    default:
      return 'It is recommended to consult a healthcare professional for further guidance.';
  }
}


IconData _statusIcon(String riskLevel) {
  switch (riskLevel) {
    case 'Low':
      return Icons.emoji_events_rounded; // celebration
    case 'Medium':
      return Icons.info_rounded; // neutral info
    case 'High':
    default:
      return Icons.health_and_safety_rounded; // professional advice
  }
}


  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(result.riskLevel);

    return Scaffold(
     appBar: const GradientAppBar(title: 'நெற்றிக்கண்'),

      body: GradientBackground( 
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FadeSlide(
                      offset: Offset(0, 16),
                      child: SafeLottie(
                        asset: AppIcons.appLogo,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF8F94FB),
                          Color(0xFF4E54C8),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Your Screening Result',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: result.score),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        final normalized = (value / 10).clamp(0.0, 1.0);
                        return Column(
                          children: [
                            SizedBox(
                              height: 120,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 110,
                                    width: 110,
                                    child: CircularProgressIndicator(
                                      value: normalized,
                                      strokeWidth: 8,
                                      backgroundColor:
                                          Colors.grey.withValues(alpha: 0.2),
                                      valueColor: AlwaysStoppedAnimation(
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    value.toStringAsFixed(1),
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 300, // prevents overflow – adjust if needed
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  statusColor.withValues(alpha: 0.18),
                                  statusColor.withValues(alpha: 0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  _statusIcon(result.riskLevel),
                                  size: 18,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    _statusLabel(result.riskLevel),
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Attention',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'This screening offers an initial understanding. '
                        'If you feel you need more clarity, you may speak with a child specialist for additional guidance.',
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 28),
                    MorphicButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomePage.routeName,
                          (route) => false,
                        );
                      },
                      child: const Text('Back to Home'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          ResultsHistoryPage.routeName,
                        );
                      },
                      child: const Text('View Past Results'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
