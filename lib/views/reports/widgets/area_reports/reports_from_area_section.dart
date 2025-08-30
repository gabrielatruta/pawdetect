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

  @override
  void initState() {
    super.initState();
    _visibleCount = widget.limit; // start with one "page"
  }

  // if filters change (user changed selected areas/animals), reset paging
  @override
  void didUpdateWidget(covariant ReportsFromAreaSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filtersByAnimal != widget.filtersByAnimal ||
        oldWidget.limit != widget.limit) {
      setState(() {
        _visibleCount = widget.limit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.serviceOverride ?? ReportService();

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
            // Header (same spacing as AllReportsForm)
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
              // Bind the Firestore page size to _visibleCount so the stream
              // delivers 4, then 8, then 12… and auto-refreshes via snapshots().
              StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                stream: service.watchFoundReportsByAnimalAreaFilters(
                  filters: widget.filtersByAnimal,
                  limit: _visibleCount,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: LinearProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _InfoBox('Failed to load area reports.'),
                    );
                  }

                  final docs = snapshot.data ?? const [];
                  if (docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _InfoBox(
                        'No found reports in your selected area yet.',
                      ),
                    );
                  }

                  final items = docs
                      .map((d) => report.Report.fromFirestore(d.id, d.data()))
                      .toList();

                  // If Firestore returned exactly the requested amount,
                  // assume there *may* be more available and show the Load More card.
                  final hasMore = items.length == _visibleCount;

                  return SizedBox(
                    height: 190, // room for image + footer in SmallReportCard
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length + (hasMore ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        // trailing "Load more" tile
                        if (hasMore && i == items.length) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _visibleCount += widget.limit; // request +4
                              });
                            },
                            child: const ReportCardLoadMore(),
                          );
                        }

                        final r = items[i];
                        final img = (r.photoUrls.isNotEmpty)
                            ? r.photoUrls.first
                            : '';
                        return GestureDetector(
                          onTap: () {
                            if (widget.onOpen != null) {
                              widget.onOpen!(r);
                              return;
                            }
                            final id = r.id ?? '';
                            if (id.isEmpty) return;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReportDetailsScreen(reportId: id),
                              ),
                            );
                          },
                          child: SmallReportCard(
                            title: r.location.isNotEmpty
                                ? r.location
                                : 'Found report',
                            imageUrl: img,
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
