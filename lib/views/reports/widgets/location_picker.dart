import 'package:flutter/material.dart';

class LocationPicker extends StatelessWidget {
  final ValueChanged<String> onLocationPicked;
  const LocationPicker({super.key, required this.onLocationPicked});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Location"),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: implement map picker or GPS fetch
            onLocationPicked("fake_location_coordinates");
          },
          icon: const Icon(Icons.location_on),
          label: const Text("Pick Location"),
        ),
      ],
    );
  }
}
