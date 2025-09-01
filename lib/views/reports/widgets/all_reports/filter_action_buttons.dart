import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/report/all_reports_viewmodel.dart';

class FilterActionButtons extends StatelessWidget {
  const FilterActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Consumer<AllReportsViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Expanded(
              child: SecondaryButton(
                text: loc.filter_clear_all,
                onPressed: () {
                  viewModel.clearFilters();
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                text: loc.filter_apply,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
