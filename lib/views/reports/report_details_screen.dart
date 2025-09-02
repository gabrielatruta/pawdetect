import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/l10n/loc_maps.dart';
import 'package:pawdetect/models/report_model.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/report_details/report_details_card.dart';
import 'package:pawdetect/views/reports/widgets/report_details/report_header_card.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/report/report_details_viewmodel.dart';
import 'package:pawdetect/services/report_service.dart';

class ReportDetailsScreen extends StatelessWidget {
  final String reportId;
  const ReportDetailsScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return ChangeNotifierProvider(
      create: (_) => ReportDetailsViewModel(ReportService())..load(reportId),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: CustomAppBar(title: loc.report),
        body: Consumer<ReportDetailsViewModel>(
          builder: (_, vm, __) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              );
            }
            if (vm.error != null) {
              final msg = vm.error == loc.report_not_found
                  ? loc.report_not_found
                  : loc.report_error_generic;
              return Center(child: Text(msg));
            }

            final r = vm.reportData!;

            // Title
            final base =
                '${LocMaps.type(r.type.value, loc)} ${LocMaps.animal(r.animal.value, loc)}';
            final status = LocMaps.status(vm.statusLabel, loc);
            final titleText = status.isEmpty ? base : '$base ($status)';

            // Details (labels + selected values)
            final localizedItems = vm.detailFields
                .map(
                  (e) => MapEntry(
                    LocMaps.detailLabel(e.key, loc),
                    LocMaps.detailValue(e.key, e.value, loc),
                  ),
                )
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header: title + image
                  ReportHeaderCard(title: titleText, imageUrl: vm.imageUrl),
                  const SizedBox(height: 12),

                  // Details
                  ReportDetailsCard(items: localizedItems),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
