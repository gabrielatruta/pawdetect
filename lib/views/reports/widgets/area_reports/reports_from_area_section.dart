import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';

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
          const _NoReportsInAreaMessage(text: 'No alerts/areas selected yet.')
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
                return const _NoReportsInAreaMessage(
                  text: 'No found reports in your selected area yet.',
                );
              }

              final items = docs
                  .map((d) => report.Report.fromFirestore(d.id, d.data()))
                  .toList();

              final count = items.length < limit ? items.length : limit;
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: count,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final r = items[i];
                  final subtitle = [
                    r.animal.name,
                    if (r.gender.name.isNotEmpty) r.gender.name,
                  ].join(' • ');

                  return ListTile(
                    leading: const Icon(Icons.pets),
                    title: Text(
                      r.location.isNotEmpty ? r.location : 'Found report',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: onOpen == null ? null : () => onOpen!(r),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}

class _NoReportsInAreaMessage extends StatelessWidget {
  const _NoReportsInAreaMessage({required this.text});
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