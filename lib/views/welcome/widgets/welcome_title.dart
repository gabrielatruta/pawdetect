import 'package:flutter/material.dart';
import '../../../../styles/app_colors.dart';

class WelcomeTitle extends StatelessWidget {
  const WelcomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          TextSpan(
            text: "Paw",
            style: TextStyle(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w800,
              fontSize: 28,
            ),
          ),
          TextSpan(
            text: "Detect",
            style: TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.w800,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}
