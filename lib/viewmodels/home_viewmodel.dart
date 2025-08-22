import 'package:flutter/material.dart';
import 'my_reports_viewmodel.dart'; // reuse Report model

class HomeViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  void changeTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // Example: fake feed of reports (you can later fetch from Firestore)
  final List<Report> feedReports = [
    Report(
      id: "101",
      petType: "Dog",
      description: "Lost brown dog spotted in the park.",
      location: "Central Park",
    ),
    Report(
      id: "102",
      petType: "Cat",
      description: "White kitten with blue eyes near main square.",
      location: "Downtown",
    ),
  ];
}
