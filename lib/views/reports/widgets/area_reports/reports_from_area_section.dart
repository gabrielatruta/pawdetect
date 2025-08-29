// lib/views/reports/widgets/area_reports/reports_from_area_section.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';
import 'package:pawdetect/views/reports/widgets/area_reports/small_report_card.dart';
import 'package:pawdetect/styles/app_colors.dart';

class ReportsFromAreaSection extends StatelessWidget {
  const ReportsFromAreaSection({
    super.key,
    required this.filtersByAnimal, // {AnimalType.dog: ['Cluj', ...], ...}
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

    return Padding(
      // Match AllReportsForm outer padding
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        // Match AllReportsForm Card style exactly
        margin: EdgeInsets.zero,
        elevation: 3,
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

            if (filtersByAnimal.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _InfoBox('No alerts/areas selected yet.'),
              )
            else
              StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                stream: service.watchFoundReportsByAnimalAreaFilters(
                  filters: filtersByAnimal,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: LinearProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text('Error: ${snapshot.error}'),
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
                  final count = items.length < limit ? items.length : limit;

                  // Content padding matches AllReportsForm (uses EdgeInsets.all(16))
                  return SizedBox(
                    height: 190, // room for image + fixed footer in SmallReportCard
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      itemCount: count,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final r = items[i];
                        final img = (r.photoUrls.isNotEmpty) ? r.photoUrls.first : '';
                        return GestureDetector(
                          onTap: onOpen == null ? null : () => onOpen!(r),
                          child: SmallReportCard(
                            title: r.location.isNotEmpty ? r.location : 'Found report',
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
