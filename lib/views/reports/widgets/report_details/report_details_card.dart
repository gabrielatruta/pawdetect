import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/reports/widgets/report_details/report_details_item.dart';

class ReportDetailsCard extends StatelessWidget {
  final List<MapEntry<String, String>> items;
  const ReportDetailsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final e in items) ...[
              ReportDetailsItem(label: e.key, value: e.value),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
