import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/views/shared/custom_dropdown.dart';


class ReportTypeField extends StatelessWidget {
  final report.ReportType? value;
  final ValueChanged<report.ReportType?> onChanged;

  const ReportTypeField({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<report.ReportType>(
      value: value,
      labelText: "Report Type",
      items: report.ReportType.values
          .map((t) => DropdownMenuItem(value: t, child: Text(t.value)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select a report type" : null,
    );
  }
}
