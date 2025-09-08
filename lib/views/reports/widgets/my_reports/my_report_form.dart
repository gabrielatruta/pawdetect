import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/l10n/loc_maps.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_border_services.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/reports/my_reports_edit_screen.dart';
import 'package:pawdetect/views/reports/report_details_screen.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_card_load_more.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_card_stretched.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/report/my_reports_viewmodel.dart';
import 'package:pawdetect/views/shared/error_message.dart';

class MyReportsForm extends StatelessWidget {
  const MyReportsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyReportsViewModel>();
    final myReports = vm.reports;

    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    if (myReports.isEmpty) {
      return Center(child: Text(loc.report_no_personal));
    }

    if (vm.isLoading && vm.reports.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }

    if (vm.errorMessage != null) {
      return Center(child: ErrorMessage(message: vm.errorMessage!));
    }

    // load 4 reports at a time
    final items = vm.visibleReports; // List<MyReportItem>

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + (vm.hasMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        // Load More card at the end
        final isLoadMoreTile = vm.hasMore && index == items.length;
        if (isLoadMoreTile) {
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: vm.loadMore,
            child: const ReportCardLoadMore(),
          );
        }

        // Report items
        final item = items[index]; // MyReportItem

        return Stack(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportDetailsScreen(reportId: item.id),
                  ),
                );
                // Mark as opened so border flips orange -> grey (if unchanged)
                await ReportBorderService.instance.markOpened(item.id);
                // ignore: use_build_context_synchronously
                await context.read<MyReportsViewModel>().fetchReports();
              },
              child: FutureBuilder<Color>(
                future: ReportBorderService.instance.colorFor(item),
                builder: (context, snap) {
                  final c = snap.data ?? AppColors.grey300;
                  return ReportCardStretched(
                    title:
                        '${LocMaps.type(item.reportType, loc)} ${LocMaps.animal(item.petType, loc)}',
                    borderColor: c,
                  );
                },
              ),
            ),

            // pencil icon
            if (item.status == report.ReportStatus.unsolved)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  color: AppColors.darkOrange,
                  tooltip: loc.report_edit,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MyReportDetailsScreen(reportId: item.id),
                      ),
                    ).then(
                      // ignore: use_build_context_synchronously
                      (_) => context.read<MyReportsViewModel>().fetchReports(),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
