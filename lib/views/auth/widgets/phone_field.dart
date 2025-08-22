import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const PhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]')),
      ],
      decoration: const InputDecoration(labelText: "Phone Number"),
      validator: (v) {
        final value = v?.trim() ?? '';
        if (value.isEmpty) return "Please enter your phone number!";
        final digits = value.replaceAll(RegExp(r'\D'), '');
        if (digits.length < 7 || digits.length > 15) {
          return "Enter a valid phone number";
        }
        return null;
      },
    );
  }
}
