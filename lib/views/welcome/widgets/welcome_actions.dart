import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/primary_button.dart';
import 'package:pawdetect/views/shared/secondary_button.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/welcome_viewmodel.dart';
import 'welcome_guest_option.dart';

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WelcomeViewModel>();

    return Column(
      children: [
        PrimaryButton(
          text: "Log In",
          onPressed: () => vm.goToLogin(context),
        ),
        const SizedBox(height: 16),
        SecondaryButton(
          text: "Sign Up",
          onPressed: () => vm.goToSignup(context),
        ),
        const SizedBox(height: 16),
        const WelcomeGuestOption(),
      ],
    );
  }
}
