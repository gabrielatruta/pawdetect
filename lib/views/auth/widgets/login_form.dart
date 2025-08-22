import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/auth/widgets/email_field.dart';
import 'package:pawdetect/views/auth/widgets/password_field.dart';
import 'package:pawdetect/views/shared/primary_button.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/login_viewmodel.dart';
import '../../home/home_screen.dart';

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
          PasswordField(controller: _passwordController),

          const SizedBox(height: 1),

           // Forgot Password?
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/forgot-password");
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: AppColors.orange),
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
                  Navigator.pushReplacementNamed(context, "/home");
                } else if (loginViewModel.errorMessage != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loginViewModel.errorMessage!)),
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
                  Navigator.pushNamed(context, "/signup");
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
