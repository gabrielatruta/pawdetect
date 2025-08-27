import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/filter_button.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/all_reports_viewmodel.dart';
import 'package:pawdetect/views/shared/report_card_load_more.dart';
import 'package:pawdetect/views/shared/report_card_stretched.dart';
import 'package:pawdetect/views/shared/error_message.dart';

class AllReportsForm extends StatelessWidget {
  const AllReportsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final allReportsViewModel = context.watch<AllReportsViewModel>();
    final allReports = allReportsViewModel.reports;

    if (allReportsViewModel.isLoading && allReports.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.orange));
    }

    if (allReportsViewModel.errorMessage != null) {
      return Center(
        child: ErrorMessage(message: allReportsViewModel.errorMessage!),
      );
    }

    if (allReports.isEmpty) {
      return const Center(child: Text("No reports available"));
    }

    final items = allReportsViewModel.visibleReports;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [FilterButton()],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: items.length + (allReportsViewModel.hasMore ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final isLoadMoreTile =
                allReportsViewModel.hasMore && index == items.length;
            if (isLoadMoreTile) {
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: allReportsViewModel.loadMore,
                child: const ReportCardLoadMore(),
              );
            }

            final item = items[index];
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text("Report Details")),
                      body: Center(
                        child: Text(
                          "Viewing report: \nID: ${item.id}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: ReportCardStretched(
                title: "${item.type.value} ${item.animal.value}",
              ),
            );
          },
        ),
      ],
    );
  }
}