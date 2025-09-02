import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';
import 'package:provider/provider.dart';

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
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return CustomInputField(
      label: loc.phone,
      controller: controller,
      isRequired: isRequired,
      keyboardType: TextInputType.phone,
      validator: (v) {
        final value = v?.trim() ?? '';

        // if not required, no value is ok
        if (!isRequired && value.isEmpty) return null;

        if (value.isEmpty) return loc.phone_empty;

        final digits = value.replaceAll(RegExp(r'\D'), '');
        if (digits.length < 7 || digits.length > 15) {
          return loc.phone_invalid;
        }
        return null;
      },
    );
  }
}
