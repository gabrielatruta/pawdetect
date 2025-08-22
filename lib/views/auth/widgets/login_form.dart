import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/login_viewmodel.dart';
import '../../shared/custom_button.dart';
import '../../shared/error_message.dart';
import '../../shared/loading_indicator.dart';
import 'email_field.dart';
import 'password_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailField(controller: _email),
          PasswordField(controller: _password),
          const SizedBox(height: 16),

          if (vm.errorMessage != null)
            ErrorMessage(message: vm.errorMessage!),

          vm.isLoading
              ? const LoadingIndicator()
              : CustomButton(
                  text: "Log In",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final user = await vm.login(
                        _email.text,
                        _password.text,
                      );
                      if (user != null && mounted) {
                        // Navigate to Home (adjust to your app flow)
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    }
                  },
                ),
        ],
      ),
    );
  }
}
