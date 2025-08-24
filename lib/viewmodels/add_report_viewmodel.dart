import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';

class AddReportViewModel extends ChangeNotifier {
  final ReportService _reportService = ReportService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> submitReport({
    required report.ReportType reportType,
    required report.AnimalType animalType,
    required report.Gender gender,
    required report.FurColor furColor,
    required String description,
    required String phone1,
    String? phone2,
    required String location,
    double? lat,
    double? lng,
    XFile? photo,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      if (location.trim().isEmpty) {
        throw Exception('Please select a location.');
      }
      if (phone1.trim().isEmpty) {
        throw Exception('Please enter a phone number.');
      }

      // Global watchdog so UI can't be stuck forever
      await _reportService
          .createReport(
            type: reportType,
            animal: animalType,
            gender: gender,
            colors: [furColor],
            location: location.trim(),
            additionalInfo: description.trim(),
            phoneNumber1: phone1.trim(),
            phoneNumber2: (phone2 ?? '').trim().isEmpty ? null : phone2!.trim(),
            photo: photo,
            lat: lat,
            lng: lng,
          )
          .timeout(const Duration(seconds: 40));

      return true;
    } on TimeoutException {
      errorMessage =
          'Taking too long to save. Please check your connection and try again.';
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
