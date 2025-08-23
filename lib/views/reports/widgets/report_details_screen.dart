import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/viewmodels/my_reports_viewmodel.dart' as vm;

class ReportDetailsScreen extends StatelessWidget {
  final vm.Report report;

  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Report'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _row('Type', report.petType),
          const SizedBox(height: 8),
          _row('Description', report.description),
          const SizedBox(height: 8),
          _row('Location', report.location),
          const SizedBox(height: 8),
          _row('ID', report.id),
        ],
      ),
      backgroundColor: AppColors.surface,
    );
  }

  Widget _row(String label, String value) {
    final v = value.trim().isEmpty ? '-' : value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            v,
            style: const TextStyle(color: AppColors.darkGrey),
          ),
        ),
      ],
    );
  }
}
