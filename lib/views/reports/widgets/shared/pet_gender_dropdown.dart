import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/l10n/loc_maps.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_dropdown.dart';
import 'package:provider/provider.dart';

class PetGenderDropdown extends StatelessWidget {
  final report.Gender? value;
  final ValueChanged<report.Gender?> onChanged;

  const PetGenderDropdown({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return CustomDropdown<report.Gender>(
      value: value,
      labelText: loc.gender,
      items: report.Gender.values
          .map(
            (g) => DropdownMenuItem(
              value: g,
              child: Text(LocMaps.gender(g.value, loc)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? loc.gender_empty : null,
    );
  }
}
