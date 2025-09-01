import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_assets.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/auth/widgets/shared/email_field.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/auth/forgot_password_viewmodel.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forgotPasswordViewModel = context.watch<ForgotPasswordViewModel>();

    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          AppAssets.forgotPasswordPath,
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 20),

        // Email input
        EmailField(controller: _emailController),
        const SizedBox(height: 4),

        //error message for the email address
        if (forgotPasswordViewModel.errorMessage != null)
          Text(
            forgotPasswordViewModel.errorMessage!,
            style: const TextStyle(color: AppColors.errorRed),
          ),

        const SizedBox(height: 24),

        // Reset Button
        PrimaryButton(
          text: loc.password_reset,
          onPressed: () async {
            await forgotPasswordViewModel.sendResetEmail(_emailController.text);

            if (forgotPasswordViewModel.errorMessage == null &&
                context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false, // removes all previous routes
              );
            }
          },
        ),
      ],
    );
  }
}
