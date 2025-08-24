import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/views/shared/custom_dropdown.dart';

class PetGenderDropdown extends StatelessWidget {
  final report.Gender? value;
  final ValueChanged<report.Gender?> onChanged;

  const PetGenderDropdown({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<report.Gender>(
      value: value,
      labelText: "Gender",
      items: report.Gender.values
          .map((g) => DropdownMenuItem(value: g, child: Text(g.value)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select a gender" : null,
    );
  }
}
