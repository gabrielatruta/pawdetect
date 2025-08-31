import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/reports/report_details_screen.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/filter_button.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_card_load_more.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_card_stretched.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/all_reports_viewmodel.dart';
import 'package:pawdetect/views/shared/error_message.dart';

class AllReportsForm extends StatelessWidget {
  const AllReportsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AllReportsViewModel>();
    final all = vm.reports;

    if (vm.isLoading && all.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }
    if (vm.errorMessage != null) {
      return Center(child: ErrorMessage(message: vm.errorMessage!));
    }
    if (all.isEmpty) {
      return const Center(child: Text("No reports available"));
    }

    final items = vm.visibleReports;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
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
            // Header (title + filter)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Text(
                    'All reports',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: items.length + (vm.hasMore ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final loadMoreTile = vm.hasMore && index == items.length;
                if (loadMoreTile) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: vm.loadMore,
                    child: const ReportCardLoadMore(),
                  );
                }

                final item = items[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () async {
                    final id = item.id;
                    if (id == null || id.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Missing report id')),
                      );
                      return;
                    }

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReportDetailsScreen(reportId: id),
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
    );
  }
}
