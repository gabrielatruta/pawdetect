import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/l10n/loc_maps.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_dropdown.dart';
import 'package:provider/provider.dart';

class PetTypeDropdown extends StatelessWidget {
  final report.AnimalType? value;
  final ValueChanged<report.AnimalType?> onChanged;

  const PetTypeDropdown({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return CustomDropdown<report.AnimalType>(
      value: value,
      labelText: loc.animal,
      items: report.AnimalType.values
          .map(
            (a) => DropdownMenuItem(
              value: a,
              child: Text(LocMaps.animal(a.value, loc)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? loc.animal_empty : null,
    );
  }
}
