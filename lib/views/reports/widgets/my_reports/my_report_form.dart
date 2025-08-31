import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/reports/my_reports_edit_screen.dart';
import 'package:pawdetect/views/reports/report_details_screen.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_card_load_more.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_card_stretched.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/my_reports_viewmodel.dart';
import 'package:pawdetect/views/shared/error_message.dart';

class MyReportsForm extends StatelessWidget {
  const MyReportsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final myReportsViewModel = context.watch<MyReportsViewModel>();
    final myReports = myReportsViewModel.reports;

    if (myReports.isEmpty) {
      return const Center(
        child: Text("No reports to display. Start reporting!"),
      );
    }

    if (myReportsViewModel.isLoading && myReportsViewModel.reports.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.orange));
    }

    if (myReportsViewModel.errorMessage != null) {
      return Center(
        child: ErrorMessage(message: myReportsViewModel.errorMessage!),
      );
    }

    // load 4 reports at a time
    final items = myReportsViewModel.visibleReports;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + (myReportsViewModel.hasMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        // Load More card at the end
        final isLoadMoreTile =
            myReportsViewModel.hasMore && index == items.length;
        if (isLoadMoreTile) {
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: myReportsViewModel.loadMore,
            child: const ReportCardLoadMore(),
          );
        }

        // Report items
        final item = items[index];
        return Stack(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportDetailsScreen(reportId: item.id),
                  ),
                );
              },
              child: ReportCardStretched(
                title: "${item.reportType} ${item.petType}",
              ),
            ),

            // pencil icon
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.edit),
                color: AppColors.darkOrange,
                tooltip: 'Edit report',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyReportDetailsScreen(reportId: item.id),
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
