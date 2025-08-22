import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<void> resetPassword(String email) async {
    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email);
      successMessage = "Password reset email sent!";
    } on FirebaseAuthException catch (e) {
      errorMessage = e.code == "user-not-found"
          ? "No user found with this email."
          : "Failed to send reset email.";
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
