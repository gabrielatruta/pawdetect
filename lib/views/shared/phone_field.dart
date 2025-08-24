import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool isRequired;

  const PhoneField({
    super.key,
    required this.controller,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      label: "Phone Number",
      controller: controller,
      isRequired: isRequired,
      keyboardType: TextInputType.phone,
      validator: (v) {
        final value = v?.trim() ?? '';

        // if not required, no value is ok
        if (!isRequired && value.isEmpty) return null;

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
