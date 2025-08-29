import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_assets.dart' show AppAssets; 

class SmallReportCard extends StatelessWidget {
  const SmallReportCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.reportImagePath, 
  });

  final String title;
  final String imageUrl;
  final String? reportImagePath; 

  static const double _footerHeight = 56; 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Default to the app's placeholder image path from AppAssets
    final ph = reportImagePath ?? AppAssets.reportImagePath;

    return SizedBox(
      width: 170,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image on top fills remaining height
            Expanded(
              child: _ImageBox(
                imageUrl: imageUrl,
                reportImagePath: ph,
              ),
            ),

            // fixed-height footer so all cards line up
            Container(
              height: _footerHeight,
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              alignment: Alignment.topLeft,
              child: Text(
                title.isNotEmpty ? title : 'Found report',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  const _ImageBox({
    required this.imageUrl,
    required this.reportImagePath,
  });

  final String imageUrl;
  final String reportImagePath;

  bool _isNetwork(String url) =>
      url.startsWith('http://') || url.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      child: _isNetwork(imageUrl) && imageUrl.trim().isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset(reportImagePath, fit: BoxFit.cover),
            )
          : Image.asset(
              reportImagePath,
              fit: BoxFit.cover,
            ),
    );
  }
}