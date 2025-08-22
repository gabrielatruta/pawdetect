import 'package:flutter/material.dart';

class WelcomeViewModel extends ChangeNotifier {
  void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }

  void goToSignup(BuildContext context) {
    Navigator.pushNamed(context, "/signup");
  }

  void continueAsGuest(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/home");
  }
}
