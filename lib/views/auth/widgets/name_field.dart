import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;
  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      label: "Username",
      controller: controller,
      keyboardType: TextInputType.name,
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? "Please enter your username!" : null,
    );
  }
}
