import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report; // has ReportType + .value

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
    return DropdownButtonFormField<report.ReportType>(
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(labelText: "Report Type"),
      items: report.ReportType.values
          .map((t) => DropdownMenuItem<report.ReportType>(
                value: t,
                child: Text(t.value), // "Found" / "Lost"
              ))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select a report type" : null,
    );
  }
}
