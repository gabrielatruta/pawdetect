import 'package:flutter/material.dart';
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

          // Email field
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
            validator: (value) =>
                value == null || value.isEmpty ? "Enter your email" : null,
          ),

          const SizedBox(height: 16),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
            validator: (value) =>
                value == null || value.isEmpty ? "Enter your password" : null,
          ),

          const SizedBox(height: 24),

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

          // Forgot Password?
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/forgot-password");
              },
              child: const Text("Forgot Password?"),
            ),
          ),

          const SizedBox(height: 20),

          // Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don’t have an account? "),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/signup");
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
