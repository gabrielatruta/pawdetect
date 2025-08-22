import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/signup_viewmodel.dart';
import '../../shared/custom_button.dart';
import '../../shared/error_message.dart';
import '../../shared/loading_indicator.dart';
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
    final vm = context.watch<SignupViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          NameField(controller: _name),
          PhoneField(controller: _phone),
          EmailField(controller: _email),
          PasswordField(controller: _password, isLogin: false,),
          ConfirmPasswordField(
            controller: _confirm,
            passwordController: _password,
          ),
          const SizedBox(height: 16),

          if (vm.errorMessage != null)
            ErrorMessage(message: vm.errorMessage!),

          vm.isLoading
              ? const LoadingIndicator()
              : CustomButton(
                  text: "Create Account",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.signUp(
                        name: _name.text,
                        email: _email.text,
                        phone: _phone.text,
                        password: _password.text,
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }
}
