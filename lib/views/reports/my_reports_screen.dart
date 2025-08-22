import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/error_message.dart';
import 'package:pawdetect/views/shared/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/my_reports_viewmodel.dart';
import 'widgets/report_list.dart';
import '../../../styles/app_colors.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MyReportsViewModel>(context, listen: false).fetchReports());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyReportsViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: const Text("My Reports"),
        centerTitle: true,
      ),
      body: vm.isLoading
          ? const LoadingIndicator()
          : vm.errorMessage != null
              ? ErrorMessage(message: vm.errorMessage!)
              : ReportList(reports: vm.reports),
    );
  }
}
