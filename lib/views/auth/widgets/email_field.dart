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
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black), // black border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ), // black border on focus
        ),
      ),
      validator: (v) {
        final value = v?.trim() ?? '';
        if (value.isEmpty) return "Please enter your email!";
        final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
        return ok ? null : "Email address is not valid!";
      },
    );
  }
}
