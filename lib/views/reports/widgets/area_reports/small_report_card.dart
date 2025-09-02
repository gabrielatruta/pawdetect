import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_assets.dart';
import 'package:pawdetect/styles/app_colors.dart';

class SmallReportCard extends StatelessWidget {
  const SmallReportCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.reportImagePath,
    this.borderColor, // override from caller
  });

  final String title;
  final String imageUrl;
  final String? reportImagePath;
  final Color? borderColor;

  static const double _footerHeight = 42;
  static const double _kBorderWidth = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ph = reportImagePath ?? AppAssets.reportImagePath;
    final radius = BorderRadius.circular(12);
    final loc = AppLocalizations.of(context)!; // localized strings

    return SizedBox(
      width: 170,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: radius,
          border: Border.all(
            width: _kBorderWidth,
            color: borderColor ?? AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackAlpha06,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // Reserve space for the border so children don't cover it
        padding: const EdgeInsets.all(_kBorderWidth),
        // Don’t clip here—clip the *inner* content to keep the border visible
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12 - _kBorderWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image on top fills remaining height
              Expanded(
                child: _ImageBox(imageUrl: imageUrl, reportImagePath: ph),
              ),

              // fixed-height footer so all cards line up
              Container(
                height: _footerHeight,
                color: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                child: Text(
                  title.isNotEmpty ? title : loc.report_found,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  const _ImageBox({required this.imageUrl, required this.reportImagePath});

  final String imageUrl;
  final String reportImagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: imageUrl.isNotEmpty
          ? Image.network(imageUrl, fit: BoxFit.cover)
          : Image.asset(reportImagePath, fit: BoxFit.cover),
    );
  }
}
