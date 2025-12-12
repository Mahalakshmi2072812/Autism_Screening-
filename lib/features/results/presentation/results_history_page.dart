import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../animations/animation_utils.dart';
import '../../../assets/assets_paths.dart';
import '../../../core/presentation/gradient_background.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/safe_lottie.dart';
import '../data/results_repository.dart';
import '../domain/questionnaire_result.dart';
import 'detailed_result_page.dart';

class ResultsHistoryPage extends StatelessWidget {
  const ResultsHistoryPage({super.key});

  static const String routeName = '/resultsHistory';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
       
        body: const Center(
          child: Text('You must be logged in to view past results.'),
        ),
      );
    }

    final stream = ResultsRepository.instance.watchResults(user.uid);

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
                  child: StreamBuilder<List<QuestionnaireResult>>(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Failed to load past results.'),
                        );
                      }

                      final results = snapshot.data ?? [];

                      if (results.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SafeLottie(
                              asset: AppIcons.appLogo,
                              height: 140,
                            ),
                            SizedBox(height: 12),
                            Text('No past results found.'),
                          ],
                        );
                      }

                      final formatter = DateFormat.yMMMd().add_jm();

                     return FadeSlide(
                        offset: const Offset(0, 10),
                        child: SizedBox(
                          height: 420,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // History title
                              Text(
                            'History',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: [
                                        Color(0xFF240090),
                                        Color(0xFF6A00FF),
                                      ],
                                    ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
                                ),
                          ),

                              const SizedBox(height: 8),
                              Text(
                                'Here are your past screening results:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),

                              // Expanded ListView for results
                              Expanded(
                                child: ListView.separated(
                                  itemCount: results.length,
                                  separatorBuilder: (context, index) => const Divider(height: 0),
                                  itemBuilder: (context, index) {
                                    final result = results[index];

                                    return ListTile(
                                      title: Text(
                                        'Score: ${result.score.toStringAsFixed(1)} (${result.riskLevel} risk)',
                                      ),
                                      subtitle: Text(
                                        formatter.format(result.createdAt.toLocal()),
                                      ),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          DetailedResultPage.routeName,
                                          arguments: result,
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
                    },
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
