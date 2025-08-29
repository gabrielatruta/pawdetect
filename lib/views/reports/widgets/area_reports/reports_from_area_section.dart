// lib/views/reports/widgets/area_reports/reports_from_area_section.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';
import 'package:pawdetect/views/reports/widgets/area_reports/small_report_card.dart';

class ReportsFromAreaSection extends StatelessWidget {
  const ReportsFromAreaSection({
    super.key,
    required this.filtersByAnimal,   // {AnimalType.dog: ['Cluj', ...], ...}
    this.limit = 10,
    this.serviceOverride,
    this.onOpen,
  });

  final Map<report.AnimalType, List<String>> filtersByAnimal;
  final int limit;
  final ReportService? serviceOverride;
  final void Function(report.Report report)? onOpen;

  @override
  Widget build(BuildContext context) {
    final service = serviceOverride ?? ReportService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Found reports in your area',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),

        if (filtersByAnimal.isEmpty)
          const _InfoBox('No alerts/areas selected yet.')
        else
          StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
            stream: service.watchFoundReportsByAnimalAreaFilters(
              filters: filtersByAnimal,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: LinearProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final docs = snapshot.data ?? const [];
              if (docs.isEmpty) {
                return const _InfoBox(
                  'No found reports in your selected area yet.',
                );
              }

              final items = docs
                  .map((d) => report.Report.fromFirestore(d.id, d.data()))
                  .toList();

              final count = items.length < limit ? items.length : limit;

              // Horizontal list of SmallReportCard
              return SizedBox(
                height: 180, // room for image + fixed footer in the card
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: count,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final r = items[i];
                    final img =
                        (r.photoUrls.isNotEmpty) ? r.photoUrls.first : '';

                    return GestureDetector(
                      onTap: onOpen == null ? null : () => onOpen!(r),
                      child: SmallReportCard(
                        title: r.location.isNotEmpty
                            ? r.location
                            : 'Found report',
                        imageUrl: img,
                        // placeholder handled internally by SmallReportCard via AppAssets
                      ),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
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
      ),
    );
  }
}