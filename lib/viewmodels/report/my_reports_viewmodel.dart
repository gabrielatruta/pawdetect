import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/services/report_service.dart';
import 'package:pawdetect/models/report_model.dart' as report;

class MyReportItem {
  final String id;
  final String reportType;
  final String petType;
  final String description;
  final String location;
  final report.ReportStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MyReportItem({
    required this.id,
    required this.reportType,
    required this.petType,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  static DateTime? _toDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  static report.ReportStatus _parseStatus(dynamic raw) {
    if (raw is report.ReportStatus) return raw;

    if (raw is String) {
      final s = raw.toLowerCase();
      // handles "solved", "ReportStatus.solved", etc.
      for (final e in report.ReportStatus.values) {
        if (e.name.toLowerCase() == s) return e;
        if ('${e.runtimeType}.$s' == e.toString().toLowerCase()) return e;
        if (e.toString().toLowerCase().endsWith('.$s')) return e;
      }
    }

    if (raw is int) {
      final idx = raw;
      if (idx >= 0 && idx < report.ReportStatus.values.length) {
        return report.ReportStatus.values[idx];
      }
    }

    // safe default (unsolved)
    return report.ReportStatus.values.first;
  }

  factory MyReportItem.fromFirestore(String id, Map<String, dynamic> data) {
    return MyReportItem(
      id: id,
      reportType: (data['type'] ?? '').toString(),
      petType: (data['animal'] ?? '').toString(),
      description: (data['additionalInfo'] ?? '').toString(),
      location: (data['location'] ?? '').toString(),
      status: _parseStatus(data['status']),
      createdAt: _toDate(data['createdAt']),
      updatedAt: _toDate(data['updatedAt']),
    );
  }
}

class MyReportsViewModel extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _reportSvc = ReportService();

  bool isLoading = false;
  String? errorMessage;

  // Full result set already filtered for the current user
  List<MyReportItem> reports = [];

  // Simple paging to display 4 results at a time
  static const int _pageSize = 4;
  int visibleCount = 0;

  bool get hasMore => visibleCount < reports.length;
  List<MyReportItem> get visibleReports => reports.take(visibleCount).toList();

  // Details state
  bool isDetailsLoading = false;
  report.Report? openedReport;
  String? openedReportId;

  // Receive notifications subscription
  bool openedReceiveFoundAlerts = false;
  String openedAlertArea = '';
  double? openedAlertLat;
  double? openedAlertLng;

  // fetch reports
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

      reports = qs.docs
          .map((d) => MyReportItem.fromFirestore(d.id, d.data()))
          .toList();

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

  // load more reports
  void loadMore() {
    if (!hasMore) return;
    final next = visibleCount + _pageSize;
    visibleCount = next <= reports.length ? next : reports.length;
    notifyListeners();
  }

  // fetch report by id
  Future<void> loadReportById(String id) async {
    isDetailsLoading = true;
    openedReport = null;
    openedReportId = id;
    notifyListeners();
    try {
      openedReport = await _reportSvc.getReportById(id);

      final snap = await FirebaseFirestore.instance
          .collection('reports')
          .doc(id)
          .get();

      final sub = (snap.data()?['foundAlertSubscription'] as Map?)
          ?.cast<String, dynamic>();
      openedReceiveFoundAlerts = (sub?['enabled'] as bool?) ?? false;
      openedAlertArea = (sub?['area'] as String?) ?? '';
      final lat = sub?['lat'];
      final lng = sub?['lng'];
      openedAlertLat = lat is num ? lat.toDouble() : null;
      openedAlertLng = lng is num ? lng.toDouble() : null;
    } finally {
      isDetailsLoading = false;
      notifyListeners();
    }
  }

  // update opened report
  Future<void> updateOpenedReport(
    Map<String, dynamic> partial, {
    XFile? newPhoto, // ← add this
  }) async {
    if (openedReportId == null) return;
    isDetailsLoading = true;
    notifyListeners();
    try {
      await _reportSvc.updateReport(
        openedReportId!,
        partial,
        newPhoto: newPhoto,
      );
      openedReport = await _reportSvc.getReportById(openedReportId!);
    } finally {
      isDetailsLoading = false;
      notifyListeners();
    }
  }
}
