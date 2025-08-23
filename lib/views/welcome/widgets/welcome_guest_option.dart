import 'package:flutter/material.dart';
import 'package:pawdetect/views/home/home_screen.dart';
import 'package:provider/provider.dart';
import '../../../../styles/app_colors.dart';
import '../../../../viewmodels/welcome_viewmodel.dart';

class WelcomeGuestOption extends StatelessWidget {
  const WelcomeGuestOption({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WelcomeViewModel>();

    return TextButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        ),
      },
      child: const Text(
        "Continue without an account",
        style: TextStyle(
          color: AppColors.grey,
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
