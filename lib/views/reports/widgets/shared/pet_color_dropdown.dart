import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report; // <- has FurColor + .value

class PetColorDropdown extends StatelessWidget {
  final report.FurColor? value;
  final ValueChanged<report.FurColor?> onChanged;

  const PetColorDropdown({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<report.FurColor>(
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(labelText: "Color(s)"),
      items: report.FurColor.values
          .map((c) => DropdownMenuItem<report.FurColor>(
                value: c,
                child: Text(c.value), // "Black", "White", ...
              ))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select a color" : null,
    );
  }
}