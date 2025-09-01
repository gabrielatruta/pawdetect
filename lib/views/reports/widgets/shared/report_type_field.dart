import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/l10n/loc_maps.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_dropdown.dart';
import 'package:provider/provider.dart';

class ReportTypeField extends StatelessWidget {
  final report.ReportType? value;
  final ValueChanged<report.ReportType?> onChanged;

  const ReportTypeField({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return CustomDropdown<report.ReportType>(
      value: value,
      labelText: loc.report_type,
      items: report.ReportType.values
          .map(
            (t) => DropdownMenuItem(
              value: t,
              child: Text(LocMaps.type(t.value, loc)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? loc.report_type_empty : null,
    );
  }
}
