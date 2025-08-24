import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/views/shared/custom_dropdown.dart';

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
    return CustomDropdown<report.FurColor>(
      value: value,
      labelText: "Color(s)",
      items: report.FurColor.values
          .map((c) => DropdownMenuItem(value: c, child: Text(c.value)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select a color" : null,
    );
  }
}
