import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class AppnNameTitle extends StatelessWidget {
  const AppnNameTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        children: [
          TextSpan(text: "Paw"),
          TextSpan(
            text: "Detect",
            style: TextStyle(color: AppColors.orange),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
