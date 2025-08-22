import 'package:flutter/material.dart';
import 'widgets/forgot_password_form.dart';
import '../../../styles/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const headerRadius = 28.0;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: const Text("Forgot Password"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(headerRadius),
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: ForgotPasswordForm(),
      ),
    );
  }
}
