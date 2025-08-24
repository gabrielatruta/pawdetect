import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/add_report_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/add_new_report/add_new_report_form.dart';

class AddNewReportScreen extends StatelessWidget {
  const AddNewReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddReportViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(title: "Add new report"),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(child: AddNewReportForm()),
          ),
        ),
      ),
    );
  }
}
