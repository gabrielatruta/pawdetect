import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';

class ProfileInformation extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  const ProfileInformation({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Account Information",
          style: const TextStyle(fontSize: 18, color: AppColors.black),
        ),
        const SizedBox(height: 16),

        CustomInputField(
          label: "Username",
          controller: nameController,
        ),
        const SizedBox(height: 12),

        CustomInputField(
          label: "Phone",
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),

        CustomInputField(
          label: "Email",
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}