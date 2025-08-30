import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';
import 'package:pawdetect/views/reports/report_details_screen.dart';
import 'package:pawdetect/views/reports/widgets/area_reports/small_report_card.dart';
import 'package:pawdetect/views/shared/report_card_load_more.dart';
import 'package:pawdetect/styles/app_colors.dart';

class ReportsFromAreaSection extends StatefulWidget {
  const ReportsFromAreaSection({
    super.key,
    required this.filtersByAnimal,
    this.limit = 4,
    this.serviceOverride,
    this.onOpen,
  });

  final Map<report.AnimalType, List<String>> filtersByAnimal;
  final int limit; // page size
  final ReportService? serviceOverride;
  final void Function(report.Report report)? onOpen;

  @override
  State<ReportsFromAreaSection> createState() => _ReportsFromAreaSectionState();
}

class _ReportsFromAreaSectionState extends State<ReportsFromAreaSection> {
  late int _visibleCount;

  // Keep one stable stream; do paging only in the widget.
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>? _stream;

  // Simple leave/return logic (no RouteObserver)
  bool _leavingToDetails = false;
  bool _wasCurrent = true;
  bool _shouldResetOnResume = false;

  static const double _kRowHeight = 190;
  static const double _kSmallCardWidth = 170;
  static const double _kLoadMoreWidth = _kSmallCardWidth / 2; // 85

  @override
  void initState() {
    super.initState();
    _visibleCount = widget.limit;
    _buildStreamFor(widget.filtersByAnimal);
  }

  // Only rebuild the stream when filters actually change.
  @override
  void didUpdateWidget(covariant ReportsFromAreaSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filtersByAnimal != widget.filtersByAnimal) {
      _visibleCount = widget.limit;
      _buildStreamFor(widget.filtersByAnimal);
    } else if (oldWidget.limit != widget.limit) {
      setState(() => _visibleCount = widget.limit);
    }
  }

  void _buildStreamFor(Map<report.AnimalType, List<String>> filters) {
    if (filters.isEmpty) {
      setState(() => _stream = Stream.value(const []));
      return;
    }
    final service = widget.serviceOverride ?? ReportService();
    // IMPORTANT: keep the stream stable: don't pass limit here.
    _stream = service.watchFoundReportsByAnimalAreaFilters(
      filters: filters,
      limit: null,
    );
    setState(() {}); // trigger rebuild with the new (stable) stream
  }

  // Minimal route watch to reset like your All Reports (no global observer)
  void _postBuildRouteWatch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      final isCurrent = route?.isCurrent ?? true;

      // Became covered by another page
      if (_wasCurrent && !isCurrent) {
        _shouldResetOnResume = !_leavingToDetails;
      }
      // Became visible again
      if (!_wasCurrent && isCurrent) {
        if (_shouldResetOnResume) {
          setState(() => _visibleCount = widget.limit);
          _shouldResetOnResume = false;
        }
      }
      _wasCurrent = isCurrent;
    });
  }

  @override
  Widget build(BuildContext context) {
    _postBuildRouteWatch();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        shadowColor: AppColors.orange600,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.grey300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'Found reports in your area',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.orange,
                    ),
              ),
            ),
            const Divider(height: 16, thickness: 0.6),

            if (widget.filtersByAnimal.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _InfoBox('No alerts/areas selected yet.'),
              )
            else
              StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                stream: _stream,
                builder: (context, snapshot) {
                  // Avoid flashing on "load more" by not showing a spinner once we’ve ever had data.
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: LinearProgressIndicator(),
                    );
                  }
                  final docs = snapshot.data ?? const [];
                  if (docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _InfoBox('No found reports in your selected area yet.'),
                    );
                  }

                  final items = docs
                      .map((d) => report.Report.fromFirestore(d.id, d.data()))
                      .toList();

                  final total = items.length;
                  final visible = math.min(_visibleCount, total);
                  final hasMore = visible < total;

                  return SizedBox(
                    height: _kRowHeight,
                    child: ListView.separated(
                      key: const PageStorageKey('areaReportsList'),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      itemCount: visible + (hasMore ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        // Half-width Load More tile
                        if (hasMore && i == visible) {
                          return SizedBox(
                            width: _kLoadMoreWidth,
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _visibleCount += widget.limit),
                              child: const ReportCardLoadMore(),
                            ),
                          );
                        }

                        final r = items[i];
                        final img =
                            (r.photoUrls.isNotEmpty) ? r.photoUrls.first : '';

                        return GestureDetector(
                          onTap: () {
                            if (widget.onOpen != null) {
                              widget.onOpen!(r);
                              return;
                            }
                            final id = r.id ?? '';
                            if (id.isEmpty) return;

                            _leavingToDetails = true;
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                  builder: (_) =>
                                      ReportDetailsScreen(reportId: id),
                                ))
                                .then((_) => _leavingToDetails = false);
                          },
                          child: SizedBox(
                            width: _kSmallCardWidth, // match SmallReportCard width
                            child: SmallReportCard(
                              title: r.location.isNotEmpty
                                  ? r.location
                                  : 'Found report',
                              imageUrl: img,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}