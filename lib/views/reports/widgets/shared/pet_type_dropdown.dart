import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report; // has AnimalType + .value

class PetTypeDropdown extends StatelessWidget {
  // (Name kept as you had it; this actually selects AnimalType)
  final report.AnimalType? value;
  final ValueChanged<report.AnimalType?> onChanged;

  const PetTypeDropdown({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<report.AnimalType>(
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(labelText: "Animal"),
      items: report.AnimalType.values
          .map((a) => DropdownMenuItem<report.AnimalType>(
                value: a,
                child: Text(a.value), // "Dog", "Cat", "Other"
              ))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select an animal" : null,
    );
  }
}
