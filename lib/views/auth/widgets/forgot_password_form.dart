import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/forgot_password_viewmodel.dart';
import '../../shared/custom_button.dart';
import '../../shared/error_message.dart';
import '../../shared/loading_indicator.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v == null || v.isEmpty
                ? "Please enter your email"
                : null,
          ),
          const SizedBox(height: 16),

          if (vm.errorMessage != null)
            ErrorMessage(message: vm.errorMessage!),

          if (vm.successMessage != null)
            Text(vm.successMessage!,
                style: const TextStyle(color: Colors.green)),

          vm.isLoading
              ? const LoadingIndicator()
              : CustomButton(
                  text: "Send Reset Email",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.resetPassword(_email.text.trim());
                    }
                  },
                ),
        ],
      ),
    );
  }
}
