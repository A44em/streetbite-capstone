import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_cubit.dart';
import '../../core/services/firestore_service.dart';
import '../../l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  final email = TextEditingController(), password = TextEditingController(), name = TextEditingController(), confirmation = TextEditingController();
  final form = GlobalKey<FormState>();
  bool register = false, busy = false;
  String? error;
  @override
  void dispose() { email.dispose(); password.dispose(); name.dispose(); confirmation.dispose(); super.dispose(); }
  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    setState(() { busy = true; error = null; });
    try {
      if (register) {
        final result = await context.read<AuthCubit>().signUp(email.text.trim(), password.text).then((_) => FirebaseAuth.instance.currentUser!);
        await result.user!.updateDisplayName(name.text.trim());
        await FirestoreService.instance.saveProfile(name: name.text.trim(), email: email.text.trim());
      } else {
        await context.read<AuthCubit>().signIn(email.text.trim(), password.text);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      setState(() => error = switch (e.code) {
        'email-already-in-use' => l.authEmailUsed,
        'weak-password' => l.authWeakPassword,
        'invalid-credential' || 'wrong-password' || 'user-not-found' || 'invalid-email' => l.authInvalid,
        _ => l.error,
      });
    } catch (_) {
      if (mounted) setState(() => error = AppLocalizations.of(context)!.error);
    } finally { if (mounted) setState(() => busy = false); }
  }
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: Form(key: form, child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(28), children: [
      const Icon(Icons.ramen_dining_rounded, size: 68, color: Color(0xFFE86B36)),
      const SizedBox(height: 12), Text(register ? l.createYourAccount : l.welcomeBack, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 24),
      if (register) TextFormField(key: const Key('signup_name'), controller: name, decoration: InputDecoration(labelText: l.fullName), validator: (v) { final s = v?.trim() ?? ''; return s.isEmpty || !RegExp(r'^[A-Z]').hasMatch(s) ? l.nameRequired : null; }),
      TextFormField(key: const Key('login_email'), controller: email, decoration: InputDecoration(labelText: l.email), keyboardType: TextInputType.emailAddress, validator: (v) => !RegExp(r'^[^@ ]+@[^@ ]+\.[^@ ]+$').hasMatch(v?.trim() ?? '') ? l.invalidInput : null),
      TextFormField(key: const Key('login_password'), controller: password, decoration: InputDecoration(labelText: l.password), obscureText: true, validator: (v) => (v?.length ?? 0) < 6 ? l.passwordShort : null),
      if (register) TextFormField(key: const Key('signup_confirm'), controller: confirmation, decoration: InputDecoration(labelText: l.confirmPassword), obscureText: true, validator: (v) => v != password.text ? l.passwordMismatch : null),
      if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
      const SizedBox(height: 20), FilledButton(key: const Key('auth_submit'), onPressed: busy ? null : submit, child: busy ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(register ? l.signUp : l.signIn)),
      TextButton(onPressed: busy ? null : () => setState(() { register = !register; error = null; }), child: Text(register ? l.signIn : l.signUp)),
    ]))))));
  }
}
