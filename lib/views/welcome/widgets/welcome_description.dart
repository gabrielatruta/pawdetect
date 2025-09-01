import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:provider/provider.dart';

class WelcomeDescription extends StatelessWidget {
  const WelcomeDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Text(
      loc.welcome_subtitle,
      style: TextStyle(fontSize: 14, color: AppColors.black),
      textAlign: TextAlign.center,
    );
  }
}
