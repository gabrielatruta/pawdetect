import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../styles/app_colors.dart';
import '../../../../viewmodels/welcome_viewmodel.dart';

class WelcomeGuestOption extends StatelessWidget {
  const WelcomeGuestOption({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WelcomeViewModel>();

    return TextButton(
      onPressed: () => vm.continueAsGuest(context),
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
