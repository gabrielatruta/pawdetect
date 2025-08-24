import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool isRequired;

  const CustomInputField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseLabelStyle = const TextStyle(color: Colors.black);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        label: _buildLabel(baseLabelStyle),
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: AppColors.lightBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildLabel(TextStyle base) {
    if (!isRequired) {
      return Text(label, style: base);
    }
    return RichText(
      text: TextSpan(
        text: label,
        style: base,
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
