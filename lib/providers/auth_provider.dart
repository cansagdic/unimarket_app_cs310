import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  StreamSubscription<User?>? _sub;

  User? user;
  bool initializing = true;

  AuthProvider() {
    _sub = _service.authStateChanges().listen((u) {
      user = u;
      initializing = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _service.signIn(email: email, password: password);
  }

  Future<void> register(String email, String password, {String? displayName}) async {
    final cred = await _service.signUp(email: email, password: password);
    if (displayName != null && cred.user != null) {
      await cred.user!.updateDisplayName(displayName);
      await cred.user!.reload();
      user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.signOut();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
