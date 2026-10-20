import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../injection.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

/// Root route that follows Firebase's session stream.
///
/// Onboarding completion is tracked here rather than by replacing this route,
/// so a successful sign-in on first launch still switches to [HomeScreen].
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late bool onboardingSeen =
      sl<SharedPreferences>().getBool(OnboardingScreen.seenKey) == true;

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data != null) return const HomeScreen();
          return onboardingSeen
              ? const AuthScreen()
              : OnboardingScreen(
                  onContinue: () => setState(() => onboardingSeen = true));
        },
      );
}
