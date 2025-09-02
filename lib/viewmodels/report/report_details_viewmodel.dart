import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';

class ReportDetailsViewModel extends ChangeNotifier {
  ReportDetailsViewModel(this._reportService);
  final ReportService _reportService;

  bool isLoading = false;
  String? error;
  report.Report? reportData;

  Future<void> load(String reportId) async {
    isLoading = true;
    error = null;
    reportData = null;
    notifyListeners();
    try {
      reportData = await _reportService.getReportById(reportId);
      if (reportData == null) error = 'Report not found';
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // status string
  String get statusLabel {
    final s = reportData?.status;
    if (s == null) return '';
    return s == report.ReportStatus.solved ? 'solved' : 'unsolved';
  }

  // image of the report
  String? get imageUrl => (reportData?.photoUrls.isNotEmpty ?? false)
      ? reportData!.photoUrls.first
      : null;

  // details of the report
  List<MapEntry<String, String>> get detailFields {
    final reportRetrieved = reportData;
    if (reportRetrieved == null) return const [];

    String? nonEmpty(String? s) => (s ?? '').trim().isEmpty ? null : s!.trim();

    final fields = <MapEntry<String, String>>[];

    final location = nonEmpty(reportRetrieved.location);
    if (location != null) fields.add(MapEntry('Location', location));

    final gender = reportRetrieved.gender.value;
    if (gender.isNotEmpty && gender != '?') {
      fields.add(MapEntry('Gender', gender));
    }

    final colors = reportRetrieved.colors.map((c) => c.value).join(', ');
    if (colors.isNotEmpty) fields.add(MapEntry('Colors', colors));

    final info = nonEmpty(reportRetrieved.additionalInfo);
    if (info != null) fields.add(MapEntry('Additional info', info));

    final phone1 = nonEmpty(reportRetrieved.phoneNumber1);
    if (phone1 != null) fields.add(MapEntry('Phone 1', phone1));

    final phone2 = nonEmpty(reportRetrieved.phoneNumber2);
    if (phone2 != null) fields.add(MapEntry('Phone 2', phone2));

    final updated = reportRetrieved.updatedAt ?? reportRetrieved.createdAt;
    if (updated != null) {
      fields.add(MapEntry('Last updated', convertDateToString(updated)));
    }

    return fields;
  }

  static String convertDateToString(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '$y-$m-$day $hh:$mm';
  }
}
