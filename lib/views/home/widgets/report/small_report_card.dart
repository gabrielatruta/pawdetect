import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/reports_image.dart';

class SmallReportCard extends StatelessWidget {
  const SmallReportCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(width: 56, height: 56, child: ReportsImage()),
          ),
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
