// lib/views/reports/widgets/reports_from_area.dart
import 'package:flutter/material.dart';
import 'package:pawdetect/views/home/widgets/report/small_report_card.dart';

/// Minimal item used by the list.
class SimpleReport {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;

  const SimpleReport({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

/// A simple, scrollable list of SmallReportCard widgets.
class ReportsFromArea extends StatelessWidget {
  const ReportsFromArea({
    super.key,
    required this.items,
  });

  final List<SimpleReport> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final r = items[i];
        return SmallReportCard(
          title: r.title,
          imageUrl: r.imageUrl, 
        );
      },
    );
  }
}
