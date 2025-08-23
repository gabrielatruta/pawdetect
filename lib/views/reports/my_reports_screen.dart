import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/my_reports_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/myreports/my_report_form.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MyReportsViewModel>(context, listen: false).fetchReports(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Keep the watch to trigger rebuilds if needed at screen level
    context.watch<MyReportsViewModel>();

    return const Scaffold(
      appBar: CustomAppBar(title: "My reports"),
      body: MyReportsForm(),
      backgroundColor: AppColors.surface,
    );
  }
}
