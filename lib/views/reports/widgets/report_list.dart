import 'package:flutter/material.dart';
import '../../../viewmodels/my_reports_viewmodel.dart';
import 'report_item.dart';

class ReportList extends StatelessWidget {
  final List<Report> reports;
  const ReportList({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Center(child: Text("No reports yet."));
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return ReportItem(report: reports[index]);
      },
    );
  }
}
