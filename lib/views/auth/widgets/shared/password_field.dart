import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final bool isLogin;
  const PasswordField({
    super.key,
    required this.controller,
    required this.isLogin,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      label: "Password",
      controller: widget.controller,
      obscureText: _obscure,
      suffixIcon: IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      validator: (v) {
        final value = v?.trim() ?? '';
        if (value.isEmpty) return "Please enter your password!";
        final regex = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
        );
        if (!regex.hasMatch(value) && !widget.isLogin) {
          return "Password must be at least 8 characters, include \nan uppercase letter, number and symbol.";
        }
        return null;
      },
    );
  }
}
