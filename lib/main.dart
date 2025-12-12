import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/home/presentation/home_page.dart';
import 'features/questionnaire/presentation/questionnaire_page.dart';
import 'features/results/domain/questionnaire_result.dart';
import 'features/results/presentation/detailed_result_page.dart';
import 'features/results/presentation/result_page.dart';
import 'features/results/presentation/results_history_page.dart';
import 'splash/splash_page.dart';
import 'theme/app_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final user = FirebaseAuth.instance.currentUser;

  runApp(MentalHealthScreeningApp(isLoggedIn: user != null));
}

class MentalHealthScreeningApp extends StatelessWidget {
  const MentalHealthScreeningApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'நெற்றிக்கண்',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        HomePage.routeName: (context) => const HomePage(),
        QuestionnairePage.routeName: (context) => const QuestionnairePage(),
        ResultsHistoryPage.routeName: (context) => const ResultsHistoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ResultPage.routeName) {
          final args = settings.arguments;
          if (args is QuestionnaireResult) {
            return MaterialPageRoute(
              builder: (context) => ResultPage(result: args),
            );
          }
        }

        if (settings.name == DetailedResultPage.routeName) {
          final args = settings.arguments;
          if (args is QuestionnaireResult) {
            return MaterialPageRoute(
              builder: (context) => DetailedResultPage(result: args),
            );
          }
        }
        
        return null;
      },
    );
  }
}
