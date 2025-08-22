import 'package:flutter/material.dart';

class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'web/icons/welcomeScreenPaw.png',
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }
}
