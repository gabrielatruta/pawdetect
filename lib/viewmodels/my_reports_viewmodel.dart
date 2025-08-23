import 'package:flutter/material.dart';

/// Simple Report model (kept from your project; replace with your real model when ready)
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
  final List<Report> reports = [];

  bool isLoading = false;
  String? errorMessage;

  // Paging
  static const int _pageSize = 4;
  int visibleCount = _pageSize;

  List<Report> get visibleReports =>
      reports.take(visibleCount.clamp(0, reports.length)).toList();

  bool get hasMore => visibleCount < reports.length;

  Future<void> fetchReports() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with Firestore fetch for the logged-in user
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Example data (keep/remove as you wish)
      reports
        ..clear()
        ..addAll([
          Report(
              id: "1",
              petType: "Dog",
              description: "Small brown dog near park.",
              location: "Central Park"),
          Report(
              id: "2",
              petType: "Cat",
              description: "Gray cat with blue collar.",
              location: "5th Avenue"),
          Report(
              id: "3",
              petType: "Other",
              description: "Parrot found on balcony.",
              location: "Elm Street"),
          Report(
              id: "4",
              petType: "Dog",
              description: "Golden retriever missing.",
              location: "Oak Road"),
          Report(
              id: "5",
              petType: "Cat",
              description: "Orange cat, very friendly.",
              location: "Maple Ave"),
          Report(
              id: "6",
              petType: "Dog",
              description: "Black lab seen by river.",
              location: "Riverside"),
          Report(
              id: "7",
              petType: "Other",
              description: "Rabbit found in garden.",
              location: "Pine Street"),
        ]);

      // Reset visible window
      visibleCount = reports.isEmpty ? 0 : _pageSize.clamp(0, reports.length);
    } catch (e) {
      errorMessage = "Failed to load reports.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void loadMore() {
    if (!hasMore) return;
    visibleCount = (visibleCount + _pageSize).clamp(0, reports.length);
    notifyListeners();
  }
}