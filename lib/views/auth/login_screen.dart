import 'package:flutter/material.dart';
import 'package:pawdetect/viewmodels/login_viewmodel.dart';
import 'package:pawdetect/views/auth/widgets/custom_appbar.dart';
import 'package:pawdetect/views/auth/widgets/login_form.dart';
import 'package:pawdetect/views/auth/widgets/login_subtitle.dart';
import 'package:pawdetect/views/shared/app_logo.dart';
import 'package:pawdetect/views/welcome/widgets/welcome_appname.dart';
import 'package:provider/provider.dart';
import '../../styles/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LoginViewModel>().clearError();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Log in"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: const [
              SizedBox(height: 20),
              AppLogo(),
              SizedBox(height: 16),
              WelcomeAppName(),
              SizedBox(height: 8),
              LoginSubtitle(),
              SizedBox(height: 24),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}