import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../animations/animation_utils.dart';
import '../../../assets/assets_paths.dart';
import '../../../core/presentation/gradient_background.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/morphic/glass_card.dart';
import '../../../widgets/morphic/morphic_button.dart';
import '../../../widgets/safe_lottie.dart';
import '../../auth/presentation/login_page.dart';
import '../../questionnaire/presentation/questionnaire_page.dart';
import '../../results/presentation/results_history_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName;
    final email = user?.email ?? '';

    return Scaffold(
      appBar: const GradientAppBar(title: 'நெற்றிக்கண்'), 

      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FadeSlide(
                      offset: Offset(0, 18),
                      child: SafeLottie(
                        asset: AppIcons.appLogo,
                        height: 140,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                          'Mental Health Screening',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.white, // required for shader mask
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
                        'Start a new questionnaire or review previous screening results.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (displayName != null && displayName.isNotEmpty)
                      FadeSlide(
                        delay: const Duration(milliseconds: 180),
                        child: Text(
                          'Signed in as $displayName',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    else if (email.isNotEmpty)
                      FadeSlide(
                        delay: const Duration(milliseconds: 180),
                        child: Text(
                          'Signed in as $email',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    const SizedBox(height: 24),
                    FadeSlide(
                      delay: const Duration(milliseconds: 220),
                      child: MorphicButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            QuestionnairePage.routeName,
                          );
                        },
                        child: const Text('Start questionnaire'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeSlide(
                      delay: const Duration(milliseconds: 260),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            ResultsHistoryPage.routeName,
                          );
                        },
                        child: const Text('View past results'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeSlide(
                      delay: const Duration(milliseconds: 300),
                      child: TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            LoginPage.routeName,
                            (route) => false,
                          );
                        },
                        child: const Text('Logout'),
                      ),
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
