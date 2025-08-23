import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/shared/reports_image.dart';

class ReportCardStretched extends StatelessWidget {
  final String title;
  final ImageProvider? image; 

  const ReportCardStretched({
    super.key,
    required this.title,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.orange, width: 1.4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          // Image
          ReportsImage(image: image, size: 56),
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
