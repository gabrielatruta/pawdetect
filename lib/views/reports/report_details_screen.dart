import 'package:flutter/material.dart';
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
    return ChangeNotifierProvider(
      create: (_) => ReportDetailsViewModel(ReportService())..load(reportId),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: CustomAppBar(title: "Report"),
        body: Consumer<ReportDetailsViewModel>(
          builder: (_, vm, __) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              );
            }
            if (vm.error != null) return Center(child: Text(vm.error!));

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header: title + image
                  ReportHeaderCard(title: vm.titleWithStatus, imageUrl: vm.imageUrl),
                  const SizedBox(height: 12),

                  // Details
                  ReportDetailsCard(items: vm.detailFields),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
