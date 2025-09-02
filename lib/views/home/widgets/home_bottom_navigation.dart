import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/reports/add_new_report_screen.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:provider/provider.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: PrimaryButton(
          text: loc.report_add_new,
          onPressed: () async {
            // Push the add-report page and wait for it to finish
            await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const AddNewReportScreen()),
            );
          },
        ),
      ),
    );
  }
}
