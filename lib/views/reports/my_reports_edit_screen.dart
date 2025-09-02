import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/report/my_reports_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/my_reports/my_report_edit_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:provider/provider.dart';

class MyReportDetailsScreen extends StatelessWidget {
  final String reportId;
  const MyReportDetailsScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    
    return ChangeNotifierProvider(
      create: (_) => MyReportsViewModel()..loadReportById(reportId),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(title: loc.report_edit_my),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<MyReportsViewModel>(
              builder: (_, vm, __) {
                if (vm.isDetailsLoading || vm.openedReport == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SingleChildScrollView(
                  child: MyReportEditForm(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
