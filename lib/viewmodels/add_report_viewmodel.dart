import 'package:flutter/material.dart';

class AddReportViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  // Example report data
  String? petType;
  String? description;
  String? photoUrl;
  String? location;

  Future<void> submitReport() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // TODO: connect to Firebase/Firestore to save the report

      await Future.delayed(const Duration(seconds: 2)); // fake API delay
    } catch (e) {
      errorMessage = "Failed to submit report.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
