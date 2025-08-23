import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;

  Future<void> sendResetEmail(String email) async {
    if (email.isEmpty) {
      errorMessage = "Please enter your email";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = "There is no account associated with this email.";
         notifyListeners();
      } else {
        errorMessage = "Invalid email";
         notifyListeners();
      }
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
       notifyListeners();
    } 
  }

  void clearMessages() {
    errorMessage = null;
    notifyListeners();
  }
}
