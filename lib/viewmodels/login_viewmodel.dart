import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;

  Future<User?> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.code == 'user-not-found'
          ? "No user found with this email."
          : e.code == 'wrong-password'
              ? "Incorrect password."
              : "Login failed. Please try again.";
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}
