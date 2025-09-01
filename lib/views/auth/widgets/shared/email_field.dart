import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';
import 'package:provider/provider.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return CustomInputField(
      label: loc.email,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        final value = v?.trim() ?? '';
        if (value.isEmpty) return loc.email_empty;
        final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
        return ok ? null : loc.email_not_valid;
      },
    );
  }
}
