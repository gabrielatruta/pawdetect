import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/l10n/loc_maps.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_dropdown.dart';
import 'package:provider/provider.dart';

class PetColorDropdown extends StatelessWidget {
  final report.FurColor? value;
  final ValueChanged<report.FurColor?> onChanged;

  const PetColorDropdown({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return CustomDropdown<report.FurColor>(
      value: value,
      labelText: loc.colors,
      items: report.FurColor.values
          .map(
            (c) => DropdownMenuItem(
              value: c,
              child: Text(LocMaps.color(c.value, loc)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? loc.colors_empty : null,
    );
  }
}
