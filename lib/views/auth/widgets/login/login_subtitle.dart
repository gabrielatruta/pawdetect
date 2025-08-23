import 'package:flutter/material.dart';

class LoginSubtitle extends StatelessWidget {
  const LoginSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Welcome back! Please log in to continue.",
      style: TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
      textAlign: TextAlign.center,
    );
  }
}
