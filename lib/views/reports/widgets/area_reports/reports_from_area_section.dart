import 'package:flutter/material.dart';
import 'package:pawdetect/views/reports/widgets/home/small_report_card.dart';

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

class ReportsFromArea extends StatelessWidget {
  const ReportsFromArea({
    super.key,
    required this.items,
    this.showLoadMore = false,
    this.onLoadMore,
  });

  final List<SimpleReport> items;
  final bool showLoadMore;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        itemCount: items.length + (showLoadMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (showLoadMore && i == items.length) {
            // Last item is the Load more button
            return Center(
              child: ElevatedButton(
                onPressed: onLoadMore,
                child: const Text("Load more"),
              ),
            );
          }

          final r = items[i];
          return SmallReportCard(title: r.title, imageUrl: r.imageUrl);
        },
      ),
    );
  }
}
