import 'package:flutter/material.dart';
import 'package:pawdetect/viewmodels/forgot_password_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'widgets/forgot_password_form.dart';
import '../../../styles/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ForgotPasswordViewModel>().clearMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
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
