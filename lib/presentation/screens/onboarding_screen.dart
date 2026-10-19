import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 850))
    ..forward();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> continueToAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen_v1', true);
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
        body: SafeArea(
            child: FadeTransition(
                opacity: controller,
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.ramen_dining_rounded,
                                      size: 116, color: Color(0xFFE86B36)),
                                  const SizedBox(height: 28),
                                  Text(l.appTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  Text(l.welcome,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  const SizedBox(height: 36),
                                  SizedBox(
                                      width: double.infinity,
                                      child: Semantics(
                                        identifier: 'onboarding_continue',
                                        button: true,
                                        child: FilledButton(
                                            onPressed: continueToAuth,
                                            child: Text(l.getStarted)),
                                      )),
                                ])))))));
  }
}
