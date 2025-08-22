import 'package:flutter/material.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/shared/primary_button.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/signup_viewmodel.dart';
import '../../shared/error_message.dart';
import 'name_field.dart';
import 'phone_field.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'confirm_password_field.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupViewModel = context.watch<SignupViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          NameField(controller: _name),
          const SizedBox(height: 16),
          PhoneField(controller: _phone),
          const SizedBox(height: 16),
          EmailField(controller: _email),
          const SizedBox(height: 16),
          PasswordField(controller: _password, isLogin: false),
          const SizedBox(height: 16),
          ConfirmPasswordField(
            controller: _confirm,
            passwordController: _password,
          ),
          const SizedBox(height: 16),

          if (signupViewModel.errorMessage != null)
            ErrorMessage(message: signupViewModel.errorMessage!),

          PrimaryButton(
            text: "Create Account",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await signupViewModel.signUp(
                  name: _name.text.trim(),
                  email: _email.text.trim(),
                  phone: _phone.text.trim(),
                  password: _password.text.trim(),
                );

                if (signupViewModel.errorMessage == null && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
