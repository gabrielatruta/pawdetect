import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/my_reports_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/my_report_details/my_report_details_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:provider/provider.dart';

class MyReportDetailsScreen extends StatelessWidget {
  final String reportId;
  const MyReportDetailsScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyReportsViewModel()..loadReportById(reportId),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(title: "Edit my report"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<MyReportsViewModel>(
              builder: (_, vm, __) {
                if (vm.isDetailsLoading || vm.openedReport == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SingleChildScrollView(
                  child: MyReportDetailsForm(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
