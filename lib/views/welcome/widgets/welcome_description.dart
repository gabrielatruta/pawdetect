import 'package:flutter/material.dart';
import '../../../../styles/app_colors.dart';

class WelcomeDescription extends StatelessWidget {
  const WelcomeDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Create your account to start reporting and finding pets.",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.grey,
        fontSize: 14,
        height: 1.35,
      ),
    );
  }
}
