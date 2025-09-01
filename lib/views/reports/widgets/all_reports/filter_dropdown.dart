import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;                 // canonical code: 'dog' | 'cat' | 'other'
  final List<String> items;            // canonical codes
  final ValueChanged<String?> onChanged;
  final String Function(String value)? display;  // maps code -> UI label

  const FilterDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.display,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map((code) => DropdownMenuItem<String>(
                    value: code,
                    child: Text(display?.call(code) ?? code),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
