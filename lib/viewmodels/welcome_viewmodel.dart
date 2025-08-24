import 'package:flutter/material.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/auth/signup_screen.dart';
import 'package:pawdetect/views/home/home_screen.dart';

class WelcomeViewModel extends ChangeNotifier {
  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  void continueAsGuest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
