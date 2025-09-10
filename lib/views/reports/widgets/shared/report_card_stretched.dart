import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_assets.dart';
import 'package:pawdetect/styles/app_colors.dart';

class ReportCardStretched extends StatelessWidget {
  final String title;
  final ImageProvider<Object>? image;
  final Color? borderColor;

  const ReportCardStretched({
    super.key,
    required this.title,
    this.image,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider displayImage =
        image ?? const AssetImage(AppAssets.noPhotoPath);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 2, color: borderColor ?? AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: displayImage,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
