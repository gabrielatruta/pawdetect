import 'package:flutter/material.dart';
import 'package:pawdetect/viewmodels/forgot_password_viewmodel.dart';
import 'package:pawdetect/views/auth/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'widgets/forgot_password_form.dart';
import '../../../styles/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ForgotPasswordViewModel>().clearMessages();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Reset password"),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: ForgotPasswordForm(),
      ),
    );
  }
}
