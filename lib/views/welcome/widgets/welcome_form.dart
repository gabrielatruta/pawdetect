import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/auth/signup_screen.dart';
import 'package:pawdetect/views/guest/guest_home_screen.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth/welcome_viewmodel.dart';

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WelcomeViewModel>();

    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Column(
      children: [
        // Log In
        PrimaryButton(
          text: loc.login,
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
          text: loc.signup,
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
              MaterialPageRoute(builder: (_) => const GuestHomeScreen()),
            ),
          },
          child: Text(
            loc.welcome_continue_as_guest,
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
