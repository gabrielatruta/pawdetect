import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/views/reports/report_details_screen.dart';
import 'package:pawdetect/views/reports/widgets/area_reports/small_report_card.dart';
import 'package:pawdetect/views/shared/report_card_load_more.dart';

class LoadMoreAreaReports extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: rowHeight,
      child: ListView.separated(
        key: PageStorageKey(pageStorageKey),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: visible + (hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          // Trailing "Load more" tile (half width)
          if (hasMore && i == visible) {
            return SizedBox(
              width: loadMoreWidth,
              child: InkWell(
                onTap: onLoadMore,
                child: const ReportCardLoadMore(),
              ),
            );
          }

          final r = items[i];
          final img = (r.photoUrls.isNotEmpty) ? r.photoUrls.first : '';

          return GestureDetector(
            onTap: () {
              if (onOpen != null) {
                onOpen!(r);
                return;
              }
              final id = r.id ?? '';
              if (id.isEmpty) return;

              onBeforeOpenDetails?.call();
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) => ReportDetailsScreen(reportId: id),
                    ),
                  )
                  .then((_) => onAfterCloseDetails?.call());
            },
            child: SizedBox(
              width: smallCardWidth,
              child: SmallReportCard(
                title: r.location.isNotEmpty ? r.location : 'Found report',
                imageUrl: img,
              ),
            ),
          );
        },
      ),
    );
  }
}