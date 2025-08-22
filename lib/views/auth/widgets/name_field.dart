import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;
  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(labelText: "Full Name"),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? "Please enter your name!" : null,
    );
  }
}
