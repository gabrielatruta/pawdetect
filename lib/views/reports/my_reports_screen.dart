import 'package:flutter/material.dart';
import 'package:pawdetect/views/reports/widgets/myreports/report_card_load_more.dart';
import 'package:pawdetect/views/reports/widgets/myreports/report_card_stretched.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/my_reports_viewmodel.dart';

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
      () => Provider.of<MyReportsViewModel>(
        context,
        listen: false,
      ).fetchReports(),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MyReportsViewModel>();

    return Scaffold(
      appBar: CustomAppBar(title: "My reports"),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const ReportCardStretched(title: "Lost Dog"),
          const SizedBox(height: 20),
          const ReportCardLoadMore(),
        ],
      ),
    );
  }
}
