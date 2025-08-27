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
    final vm = context.watch<AllReportsViewModel>();
    final allReports = vm.reports;

    if (vm.isLoading && allReports.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: ErrorMessage(message: vm.errorMessage!),
      );
    }

    if (allReports.isEmpty) {
      return const Center(child: Text("No reports available"));
    }

    final items = vm.visibleReports;

    return RefreshIndicator(
      color: AppColors.orange,
      onRefresh: () async {
        // Tries vm.refresh() first; falls back to fetchReports(forceReload: true) if available.
        try {
          await (vm as dynamic).refresh();
        } catch (_) {
          try {
            await (vm as dynamic).fetchReports(forceReload: true);
          } catch (_) {
            // No refresh API on ViewModel — silently succeed.
          }
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            // Tiny horizontal space so the card aligns visually with the map margins
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 15, // soft shadow
                shadowColor: AppColors.orange.withOpacity(0.20),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppColors.orange.withOpacity(0.10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header (title + filter)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                      child: Row(
                        children: [
                          Text(
                            'All reports',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.orange,
                                ),
                          ),
                          const Spacer(),
                          const FilterButton(),
                        ],
                      ),
                    ),
                    const Divider(height: 16, thickness: 0.6),
                    // List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length + (vm.hasMore ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final isLoadMoreTile = vm.hasMore && index == items.length;
                        if (isLoadMoreTile) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: vm.loadMore,
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
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
