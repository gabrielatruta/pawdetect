import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/auth/signup_screen.dart';
import 'package:pawdetect/views/home/home_screen.dart';
import 'package:pawdetect/views/shared/primary_button.dart';
import 'package:pawdetect/views/shared/secondary_button.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/welcome_viewmodel.dart';

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WelcomeViewModel>();

    return Column(
      children: [
        // Log In
        PrimaryButton(
          text: "Log In",
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          },
        ),
        const SizedBox(height: 16),

        // Sign Up
        SecondaryButton(
          text: "Sign Up",
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
            ),
          },
        ),
        const SizedBox(height: 16),

        // Continue without an account
        TextButton(
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
        ),
      ],
    );
  }
}
