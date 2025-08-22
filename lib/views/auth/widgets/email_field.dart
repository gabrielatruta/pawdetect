import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(labelText: "Email"),
      validator: (v) {
        final value = v?.trim() ?? '';
        if (value.isEmpty) return "Please enter your email!";
        final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
        return ok ? null : "Email address is not valid!";
      },
    );
  }
}
