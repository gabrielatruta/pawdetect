import 'package:flutter/material.dart';

class PetTypeDropdown extends StatelessWidget {
  final ValueChanged<String?> onChanged;
  const PetTypeDropdown({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: "Pet Type"),
      items: const [
        DropdownMenuItem(value: "Dog", child: Text("Dog")),
        DropdownMenuItem(value: "Cat", child: Text("Cat")),
        DropdownMenuItem(value: "Other", child: Text("Other")),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select a pet type" : null,
    );
  }
}
