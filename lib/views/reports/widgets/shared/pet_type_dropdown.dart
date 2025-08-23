import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/views/shared/custom_dropdown.dart';

class PetTypeDropdown extends StatelessWidget {
  final report.AnimalType? value;
  final ValueChanged<report.AnimalType?> onChanged;

  const PetTypeDropdown({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<report.AnimalType>(
      value: value,
      labelText: "Animal",
      items: report.AnimalType.values
          .map((a) => DropdownMenuItem(value: a, child: Text(a.value)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select an animal" : null,
    );
  }
}
