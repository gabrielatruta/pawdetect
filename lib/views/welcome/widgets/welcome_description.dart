import 'package:flutter/material.dart';

class WelcomeDescription extends StatelessWidget {
  const WelcomeDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Your real-time investigator searching for your lost pet!",
      style: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
      textAlign: TextAlign.center,
    );
  }
}