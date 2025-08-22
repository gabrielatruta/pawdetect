import 'package:flutter/material.dart';

class WelcomeAppName extends StatelessWidget {
  const WelcomeAppName({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(text: "Paw"),
          TextSpan(
            text: "Detect",
            style: TextStyle(color: Colors.orange),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
