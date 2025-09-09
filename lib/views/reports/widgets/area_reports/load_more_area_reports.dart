import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_border_services.dart';
import 'package:pawdetect/views/reports/report_details_screen.dart';
import 'package:pawdetect/views/reports/widgets/area_reports/small_report_card.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_card_load_more.dart';
import 'package:pawdetect/styles/app_colors.dart';

class LoadMoreAreaReports extends StatefulWidget {
  const LoadMoreAreaReports({
    super.key,
    required this.rowHeight,
    required this.smallCardWidth,
    required this.loadMoreWidth,
    required this.items,
    required this.visible,
    required this.hasMore,
    required this.onLoadMore,
    this.onOpen,
    this.onBeforeOpenDetails,
    this.onAfterCloseDetails,
    this.pageStorageKey = 'areaReportsList',
  });

  final double rowHeight;
  final double smallCardWidth;
  final double loadMoreWidth;

  /// All matching reports (already filtered & sorted in the parent)
  final List<report.Report> items;

  /// How many items are currently visible (for paging)
  final int visible;

  /// If true, shows the trailing "Load more" tile
  final bool hasMore;

  /// Called when the load-more tile is tapped (parent increments page size)
  final VoidCallback onLoadMore;

  /// Optional callback if the parent wants to override opening a report
  final void Function(report.Report report)? onOpen;

  /// Optional hooks so the parent can mark/unmark "leaving to details"
  /// to prevent pagination reset on resume
  final VoidCallback? onBeforeOpenDetails;
  final VoidCallback? onAfterCloseDetails;

  /// Key used to preserve scroll position across rebuilds
  final String pageStorageKey;

  @override
  State<LoadMoreAreaReports> createState() => _LoadMoreAreaReportsState();
}

class _LoadMoreAreaReportsState extends State<LoadMoreAreaReports> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings

    return SizedBox(
      height: widget.rowHeight,
      child: ListView.separated(
        key: PageStorageKey(widget.pageStorageKey),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: widget.visible + (widget.hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          // Trailing "Load more" tile (half width)
          if (widget.hasMore && i == widget.visible) {
            return SizedBox(
              width: widget.loadMoreWidth,
              child: InkWell(
                onTap: widget.onLoadMore,
                child: const ReportCardLoadMore(),
              ),
            );
          }

          final r = widget.items[i];

          return GestureDetector(
            onTap: () async {
              if (widget.onOpen != null) {
                // If parent overrides navigation, let it handle everything.
                widget.onOpen!(r);
                return;
              }

              final id = r.id ?? '';
              if (id.isEmpty) return;

              widget.onBeforeOpenDetails?.call();

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReportDetailsScreen(reportId: id),
                ),
              );

              // Mark as opened so borders can flip orange -> grey (if no new updates)
              await ReportBorderService.instance.markOpened(id);

              // Rebuild this list so the FutureBuilder below re-runs and color updates
              if (mounted) setState(() {});

              widget.onAfterCloseDetails?.call();
            },
            child: SizedBox(
              width: widget.smallCardWidth,
              child: FutureBuilder<Color>(
                future: ReportBorderService.instance.colorFor(r),
                builder: (context, snap) {
                  final borderColor = snap.data ?? AppColors.border;
                  final img = (r.photoUrls.isNotEmpty) ? r.photoUrls.first : '';
                  return SmallReportCard(
                    title: r.location.isNotEmpty
                        ? r.location
                        : loc.report_found,
                    imageUrl: img,
                    borderColor: borderColor,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
