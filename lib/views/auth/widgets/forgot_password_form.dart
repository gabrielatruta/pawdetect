import 'package:flutter/material.dart';
import 'package:pawdetect/views/auth/widgets/email_field.dart';
import 'package:pawdetect/views/shared/primary_button.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/forgot_password_viewmodel.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          'web/icons/ForgotPassword.jpg',
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 20),

        // Email input
        EmailField(controller: _emailController),
        const SizedBox(height: 4),

        //error message for the email address
        if (vm.errorMessage != null)
          Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)),

        if (vm.successMessage != null)
          Text(vm.successMessage!, style: const TextStyle(color: Colors.green)),

        const SizedBox(height: 24),

        // Reset Button
        PrimaryButton(
          text: "Reset password",
          onPressed: () => vm.sendResetEmail(_emailController.text),
        ),
      ],
    );
  }
}
