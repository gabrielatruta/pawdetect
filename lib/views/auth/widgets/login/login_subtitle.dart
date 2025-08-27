import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class LoginSubtitle extends StatelessWidget {
  const LoginSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Welcome back! Please log in to continue.",
      style: TextStyle(
        fontSize: 16,
        color: AppColors.black,
      ),
      textAlign: TextAlign.center,
    );
  }
}
