import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class WelcomeDescription extends StatelessWidget {
  const WelcomeDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Your real-time investigator searching for your lost pet!",
      style: TextStyle(
        fontSize: 14,
        color: AppColors.black,
      ),
      textAlign: TextAlign.center,
    );
  }
}