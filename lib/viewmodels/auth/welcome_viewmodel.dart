// lib/viewmodels/welcome_view_model.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/auth/signup_screen.dart';
import 'package:pawdetect/views/home/home_screen.dart';

class WelcomeViewModel {
  static void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  static void goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  static Future<void> continueAsGuest(BuildContext context) async {
    // ensure any previous session is cleared
    await FirebaseAuth.instance.signOut();

    // go to Home and remove auth screens from back stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }
}
