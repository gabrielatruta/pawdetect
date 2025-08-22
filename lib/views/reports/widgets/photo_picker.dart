import 'package:flutter/material.dart';

class PhotoPicker extends StatelessWidget {
  final ValueChanged<String> onPhotoSelected;
  const PhotoPicker({super.key, required this.onPhotoSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Photo"),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: implement image picker + upload to Firebase Storage
            onPhotoSelected("fake_photo_url");
          },
          icon: const Icon(Icons.photo),
          label: const Text("Pick Photo"),
        ),
      ],
    );
  }
}
