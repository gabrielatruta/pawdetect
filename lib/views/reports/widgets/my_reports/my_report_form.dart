import 'package:flutter/material.dart';
import 'package:pawdetect/views/reports/widgets/my_report_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/my_reports_viewmodel.dart';
import 'package:pawdetect/views/shared/report_card_load_more.dart';
import 'package:pawdetect/views/shared/report_card_stretched.dart';
import 'package:pawdetect/views/shared/error_message.dart';


class MyReportsForm extends StatelessWidget {
  const MyReportsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyReportsViewModel>();

    if (vm.isLoading && vm.reports.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.errorMessage != null) {
      return Center(child: ErrorMessage(message: vm.errorMessage!));
    }

    final items = vm.visibleReports;

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

        final report = items[index];
        
        //Report item
        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyReportDetailsScreen(),
              ),
            );
          },
          child: ReportCardStretched(title: report.petType),
        );
      },
    );
  }
}
