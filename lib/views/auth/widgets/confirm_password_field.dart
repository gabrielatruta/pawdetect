import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';

class ConfirmPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;

  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

 class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      label: "Confirm Password",
      controller: widget.controller,
      obscureText: _obscure,
      suffixIcon: IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      validator: (v) => (v == null || v != widget.passwordController.text)
          ? "Passwords do not match"
          : null,
    );
  }
}
