import 'package:flutter/material.dart';
import '../../../viewmodels/my_reports_viewmodel.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(report.petType[0]),
        ),
        title: Text(report.petType),
        subtitle: Text("${report.description}\nLocation: ${report.location}"),
        isThreeLine: true,
      ),
    );
  }
}
