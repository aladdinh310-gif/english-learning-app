import 'package:flutter/material.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/screens/onboarding_screen.dart';
import 'features/screens/login_screen.dart';
import 'features/screens/signup_screen.dart';
import 'features/screens/home_screen.dart';
import 'features/screens/bottom_navigation_screen.dart';
import 'features/learn/presentation/screens/learn_screen.dart';
import 'features/screens/practice_screen.dart';
import 'features/progress/presentation/screens/progress_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/profile/presentation/screens/edit_profile_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/settings/presentation/screens/about_screen.dart';
import 'features/vocabulary/presentation/screens/vocabulary_screen.dart';
import 'features/grammar/presentation/screens/grammar_screen.dart';
import 'features/listening/presentation/screens/listening_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinguaLearn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.onboarding,
      routes: {
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signup: (_) => const SignupScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.bottomNavigation: (_) => const BottomNavigationScreen(),
        AppRoutes.learn: (_) => const LearnScreen(),
        AppRoutes.practice: (_) => const PracticeHubScreen(),
        AppRoutes.progress: (_) => const ProgressScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.editProfile: (_) => const EditProfileScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
        AppRoutes.about: (_) => const AboutScreen(),
        AppRoutes.vocabulary: (_) => const VocabularyScreen(),
        AppRoutes.grammar: (_) => const GrammarScreen(),
        AppRoutes.listening: (_) => const ListeningScreen(),
      },
    );
  }
}
