import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class ReportsImage extends StatelessWidget {
  final ImageProvider? image;
  final double size;

  const ReportsImage({
    super.key,
    this.image,
    this.size = 84,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: size,
        height: size,
        color: AppColors.surface,
        alignment: Alignment.center,
        child: image != null
            ? Image(image: image!, fit: BoxFit.cover)
            : const Icon(Icons.add_a_photo_outlined, color: AppColors.lightGrey),
      ),
    );
  }
}
