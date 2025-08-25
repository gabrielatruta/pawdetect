// viewmodels/report_details_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';

class ReportDetailsViewModel extends ChangeNotifier {
  ReportDetailsViewModel(this._reportService);
  final ReportService _reportService;

  bool isLoading = false;
  String? error;
  report.Report? data;

  Future<void> load(String reportId) async {
    isLoading = true;
    error = null;
    data = null;
    notifyListeners();
    try {
      data = await _reportService.getReportById(reportId);
      if (data == null) error = 'Report not found';
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}