import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class ReportCardLoadMore extends StatelessWidget {
  const ReportCardLoadMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border), // grey border
      ),
      child: const Text(
        '...',
        style: TextStyle(
          color: AppColors.grey,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}