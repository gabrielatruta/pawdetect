import 'package:flutter/material.dart';
import 'widgets/report_form.dart';
import 'package:pawdetect/views/shared/app_logo.dart';
import '../../../styles/app_colors.dart';

class AddReportScreen extends StatelessWidget {
  const AddReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const headerRadius = 28.0;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        centerTitle: true,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(headerRadius),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        title: const Text(
          'Add Report',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AppLogo(),
            SizedBox(height: 20),
            ReportForm(),
          ],
        ),
      ),
    );
  }
}
