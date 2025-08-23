import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  const DescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: const InputDecoration(labelText: "Description"),
      validator: (v) =>
          (v == null || v.isEmpty) ? "Please enter a description" : null,
    );
  }
}
