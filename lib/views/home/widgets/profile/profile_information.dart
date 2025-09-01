import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';
import 'package:provider/provider.dart';

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
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.profile_account_info,
          style: const TextStyle(fontSize: 18, color: AppColors.black),
        ),
        const SizedBox(height: 16),

        CustomInputField(label: loc.username, controller: nameController),
        const SizedBox(height: 12),

        CustomInputField(
          label: loc.phone,
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),

        CustomInputField(
          label: loc.email,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
