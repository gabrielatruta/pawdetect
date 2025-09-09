import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:provider/provider.dart';

class PreferencesForm extends StatelessWidget {
  final bool romanianLanguage;
  final ValueChanged<bool> onLanguageChanged;

  const PreferencesForm({
    super.key,
    required this.romanianLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.profile_preferences,
          style: TextStyle(fontSize: 18, color: AppColors.black),
        ),
        const SizedBox(height: 8),

        Card(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.orange, width: 1),
          ),
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              // Language switch
              SwitchListTile(
                title: Text(loc.profile_switch_language),
                value: romanianLanguage,
                activeThumbColor: AppColors.orange,
                inactiveThumbColor: AppColors.lightBackground,
                onChanged: onLanguageChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
