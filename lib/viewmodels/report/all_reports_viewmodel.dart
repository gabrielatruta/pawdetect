import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawdetect/models/report_model.dart' as report;

class AllReportsViewModel extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;
  List<report.Report> reports = [];

  static const int _pageSize = 4;
  int visibleCount = 0;

  String? _selectedAnimal;
  String? _selectedStatus;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  bool _listening = false;

  String? get selectedAnimal => _selectedAnimal;
  String? get selectedStatus => _selectedStatus;

  bool get hasMore => visibleCount < _filteredReports.length;

  // Base query (newest first)
  Query<Map<String, dynamic>> get _query =>
      _firestore.collection('reports').orderBy('createdAt', descending: true);

  // Apply active filters
  List<report.Report> get _filteredReports {
    return reports.where((r) {
      final matchesAnimal =
          _selectedAnimal == null || r.animal.value == _selectedAnimal;
      final matchesStatus =
          _selectedStatus == null || r.type.value == _selectedStatus;
      return matchesAnimal && matchesStatus;
    }).toList();
  }

  // Visible page
  List<report.Report> get visibleReports =>
      _filteredReports.take(visibleCount).toList();

  /// Start listening for changes (initial load)
  Future<void> fetchReports() async {
    if (_listening) return; // prevent duplicate listeners on hot reload
    _listening = true;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    _sub = _query.snapshots().listen(
      (qs) {
        reports = qs.docs
            .map((d) => report.Report.fromFirestore(d.id, d.data()))
            .toList();

        _applyPagination(resetIfEmpty: true);

        isLoading = false;
        errorMessage = null;
        notifyListeners();
      },
      onError: (e) {
        errorMessage = 'Failed to load reports.';
        isLoading = false;
        notifyListeners();
      },
    );
  }

  // Pagination
  void loadMore() {
    if (!hasMore) return;
    visibleCount = (visibleCount + _pageSize).clamp(0, _filteredReports.length);
    notifyListeners();
  }

  // Accepts any of: reset, resetIfEmpty
  void _applyPagination({bool reset = false, bool resetIfEmpty = false}) {
    final shouldReset = reset || resetIfEmpty;

    if (shouldReset || visibleCount == 0) {
      // Initialize or reinitialize the window
      final total = _filteredReports.length;
      visibleCount = total > _pageSize ? _pageSize : total;
      return;
    }

    // Keep current window but clamp to current filtered size
    final total = _filteredReports.length;
    visibleCount = visibleCount.clamp(0, total);
    if (visibleCount == 0 && total > 0) {
      visibleCount = total > _pageSize ? _pageSize : total;
    }
  }

  void resetPagination() {
    _applyPagination(reset: true);
    notifyListeners();
  }

  // Filters
  void setAnimalFilter(String? animal) {
    _selectedAnimal = animal;
    _applyPagination(reset: true);
    notifyListeners();
  }

  void setStatusFilter(String? status) {
    _selectedStatus = status;
    _applyPagination(reset: true);
    notifyListeners();
  }

  void clearFilters() {
    _selectedAnimal = null;
    _selectedStatus = null;
    _applyPagination(reset: true);
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void refresh() => notifyListeners();
}
