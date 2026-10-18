import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Authentication state follows Firebase's persisted session stream.
class AuthCubit extends Cubit<User?> {
  AuthCubit(this.auth) : super(auth.currentUser) {
    _subscription = auth.authStateChanges().listen(emit);
  }
  final FirebaseAuth auth;
  late final StreamSubscription<User?> _subscription;
  Future<void> signIn(String email, String password) async =>
      auth.signInWithEmailAndPassword(email: email, password: password).then((_) {});
  Future<void> signUp(String email, String password) async =>
      auth.createUserWithEmailAndPassword(email: email, password: password).then((_) {});
  Future<void> signOut() => auth.signOut();
  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
