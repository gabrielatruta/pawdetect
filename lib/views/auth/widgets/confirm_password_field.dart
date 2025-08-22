import 'package:flutter/material.dart';

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: const InputDecoration(labelText: "Confirm Password"),
      validator: (v) =>
          (v == null || v != passwordController.text)
              ? "Passwords do not match"
              : null,
    );
  }
}
