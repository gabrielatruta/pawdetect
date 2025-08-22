import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      label: "Email",
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        final value = v?.trim() ?? '';
        if (value.isEmpty) return "Please enter your email!";
        final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
        return ok ? null : "Email address is not valid!";
      },
    );
  }
}
