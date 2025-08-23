import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class PhotoPicker extends StatelessWidget {
  const PhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.photo),
        label: const Text('Pick Photo'),
        onPressed: () {
          // TODO: implement image picker + upload to Firebase Storage
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: AppColors.lightBackground,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
      ),
    );
  }
}
