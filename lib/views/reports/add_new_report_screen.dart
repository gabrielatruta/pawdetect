import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/reports/widgets/add_new_report/add_new_report_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';

class AddNewReportScreen extends StatelessWidget {
  const AddNewReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: CustomAppBar(title: "Add new report"),

      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(children: [AddNewReportForm()]),
      ),
    );
  }
}
