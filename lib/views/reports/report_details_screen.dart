import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/report_details_viewmodel.dart';
import 'package:pawdetect/services/report_service.dart';

class ReportDetailsScreen extends StatelessWidget {
  final String reportId;
  const ReportDetailsScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportDetailsViewModel(ReportService())..load(reportId),
      child: Scaffold(
        backgroundColor: const Color(0xffF7F7F7),
        appBar: AppBar(title: const Text('Report'), elevation: 0, backgroundColor: AppColors.white, foregroundColor: AppColors.darkGrey),
        body: Consumer<ReportDetailsViewModel>(
          builder: (_, vm, __) {
            if (vm.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.orange));
            if (vm.error != null) return Center(child: Text(vm.error!));
            final r = vm.data!;
            final fields = <MapEntry<String, String>>{
              MapEntry('Type', r.type.value),
              MapEntry('Animal', r.animal.value),
              MapEntry('Location', r.location),
              MapEntry('Phone', r.phoneNumber1.isNotEmpty ? r.phoneNumber1 : r.phoneNumber2),
              MapEntry('Additional info', r.additionalInfo),
              if (r.lat != null && r.lng != null) MapEntry('Coordinates', '${r.lat}, ${r.lng}'),
              if (r.createdAt != null) MapEntry('Created', r.createdAt!.toString()),
            }.where((e) => e.value.trim().isNotEmpty).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Card(
                elevation: 0,
                color: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final e in fields) ...[
                        _FieldRow(label: e.key, value: e.value),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String value;
  const _FieldRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.circle, size: 8, color: AppColors.orange),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 15, height: 1.35, color: AppColors.darkGrey)),
          ]),
        ),
      ],
    );
  }
}