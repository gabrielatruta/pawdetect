import 'package:flutter/material.dart';
import '../../../../viewmodels/my_reports_viewmodel.dart';
import 'report_card.dart';

class ReportFeed extends StatelessWidget {
  final List<Report> reports;
  const ReportFeed({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Center(child: Text("No reports in feed yet."));
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return ReportCard(report: reports[index]);
      },
    );
  }
}
