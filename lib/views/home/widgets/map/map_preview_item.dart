import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class PreviewItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const PreviewItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.orange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.3,
              color: AppColors.darkGrey,
            ),
          ),
        ),
      ],
    );
  }
}
