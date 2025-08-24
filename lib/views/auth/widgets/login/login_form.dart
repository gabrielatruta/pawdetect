import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/auth/forgot_password_screen.dart';
import 'package:pawdetect/views/auth/signup_screen.dart';
import 'package:pawdetect/views/auth/widgets/shared/email_field.dart';
import 'package:pawdetect/views/auth/widgets/shared/password_field.dart';
import 'package:pawdetect/views/home/home_screen.dart';
import 'package:pawdetect/views/shared/error_message.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/login_viewmodel.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Email field (custom widget)
          EmailField(controller: _emailController),

          const SizedBox(height: 16),

          // Password field (custom widget)
          PasswordField(controller: _passwordController, isLogin: true),

          const SizedBox(height: 1),

          // Error message from ViewModel
          if (loginViewModel.errorMessage != null &&
              loginViewModel.errorMessage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Center(
                child: ErrorMessage(message: loginViewModel.errorMessage!),
              ),
            ),

          // Forgot Password?
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: AppColors.grey),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Login button
          PrimaryButton(
            text: "Login",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final success = await loginViewModel.login(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
                if (success && mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
              }
            },
          ),

          const SizedBox(height: 5),

          // Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don’t have an account? "),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: AppColors.orange),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
