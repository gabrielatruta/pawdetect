import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawdetect/l10n/app_localizations.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SIGN IN
  Future<User?> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      final l10n = AppLocalizations.of(context)!;
      throw Exception(_mapLoginError(e, l10n));
    }
  }

  // SIGN UP
  Future<User?> signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      final l10n = AppLocalizations.of(context)!;
      throw Exception(_mapSignupError(e, l10n));
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      final l10n = AppLocalizations.of(context)!;
      throw Exception(e.message ?? l10n.default_error);
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // MAP LOGIN ERRORS
  String _mapLoginError(FirebaseAuthException e, AppLocalizations l10n) {
    switch (e.code) {
      case 'user-not-found':
        return l10n.login_no_user_found;
      case 'wrong-password':
        return l10n.login_invalid_password;
      case 'invalid-credential':
        return l10n.login_invalid_credentials;
      case 'invalid-email':
        return l10n.login_invalid_email;
      case 'network-request-failed':
        return l10n.signup_network_error;
      default:
        return l10n.default_error;
    }
  }

  // MAP SIGNUP ERRORS
  String _mapSignupError(FirebaseAuthException e, AppLocalizations l10n) {
    switch (e.code) {
      case 'email-already-in-use':
        return l10n.singup_email_already_used;
      case 'weak-password':
        return l10n.signup_password_weak;
      case 'network-request-failed':
        return l10n.signup_network_error;
      case 'operation-not-allowed':
        return l10n.singup_firebase_error;
      default:
        return l10n.default_error;
    }
  }

  // GET USER CHANGES
  Stream<User?> get userChanges => _auth.authStateChanges();
}
