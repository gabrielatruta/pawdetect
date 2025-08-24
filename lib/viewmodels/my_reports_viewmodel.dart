import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;

  // Full result set already filtered for the current user
  List<Report> reports = [];

  // Simple paging
  static const int _pageSize = 10;
  int visibleCount = 0;

  bool get hasMore => visibleCount < reports.length;
  List<Report> get visibleReports => reports.take(visibleCount).toList();

  Future<void> fetchReports() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Please sign in to view your reports.');
      }

      final qs = await _firestore
          .collection('reports')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      reports = qs.docs.map((d) {
        final data = d.data();
        return Report(
          id: d.id,
          petType: (data['animal'] ?? '').toString(),
          description: (data['additionalInfo'] ?? '').toString(),
          location: (data['location'] ?? '').toString(),
        );
      }).toList();

      visibleCount = reports.isEmpty
          ? 0
          : (_pageSize <= reports.length ? _pageSize : reports.length);
    } catch (e) {
      if (e is FirebaseException) {
        errorMessage = e.message ?? 'Failed to load reports.';
      } else {
        errorMessage = 'Failed to load reports.';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void loadMore() {
    if (!hasMore) return;
    final next = visibleCount + _pageSize;
    visibleCount = next <= reports.length ? next : reports.length;
    notifyListeners();
  }
}
