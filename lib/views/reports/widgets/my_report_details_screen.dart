import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/my_reports_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/my_report_details/my_report_details_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/viewmodels/my_reports_viewmodel.dart' as vm;
import 'package:provider/provider.dart';

class MyReportDetailsScreen extends StatelessWidget {

  const MyReportDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyReportsViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(title: "Edit my report"),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(child: MyReportDetailsForm()),
          ),
        ),
      ),
    );
  }
}
