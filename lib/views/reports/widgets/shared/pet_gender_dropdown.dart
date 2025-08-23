import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report; // has Gender + .value

class PetGenderField extends StatelessWidget {
  final report.Gender? value;
  final ValueChanged<report.Gender?> onChanged;

  const PetGenderField({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<report.Gender>(
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(labelText: "Gender"),
      items: report.Gender.values
          .map((g) => DropdownMenuItem<report.Gender>(
                value: g,
                child: Text(g.value), // "F", "M", "?"
              ))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select a gender" : null,
    );
  }
}
