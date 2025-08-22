import 'package:flutter/material.dart';

// Simple Report model (replace with your Firebase model later)
class Report {
  final String id;
  final String petType;
  final String description;
  final String location;

  Report({
    required this.id,
    required this.petType,
    required this.description,
    required this.location,
  });
}

class MyReportsViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<Report> reports = [];

  Future<void> fetchReports() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // TODO: fetch from Firebase (Firestore)
      await Future.delayed(const Duration(seconds: 2));

      // Fake data for now
      reports = [
        Report(
          id: "1",
          petType: "Dog",
          description: "Golden Retriever lost near park.",
          location: "Central Park",
        ),
        Report(
          id: "2",
          petType: "Cat",
          description: "Gray cat with blue collar spotted.",
          location: "5th Avenue",
        ),
      ];
    } catch (e) {
      errorMessage = "Failed to load reports.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
