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

  String? get selectedAnimal => _selectedAnimal;
  String? get selectedStatus => _selectedStatus;

  bool get hasMore => visibleCount < _filteredReports.length;

  // filters reports
  List<report.Report> get _filteredReports {
    return reports.where((r) {
      final matchesAnimal =
          _selectedAnimal == null || r.animal.value == _selectedAnimal;
      final matchesStatus =
          _selectedStatus == null || r.type.value == _selectedStatus;
      return matchesAnimal && matchesStatus;
    }).toList();
  }

  // 4 reports at a time
  List<report.Report> get visibleReports =>
      _filteredReports.take(visibleCount).toList();

  // fetches reports
  Future<void> fetchReports() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final qs = await _firestore
          .collection('reports')
          .orderBy('createdAt', descending: true)
          .get();

      reports = qs.docs
          .map((d) => report.Report.fromFirestore(d.id, d.data()))
          .toList();

      visibleCount = _filteredReports.length > _pageSize
          ? _pageSize
          : _filteredReports.length;
    } catch (e) {
      errorMessage = 'Failed to load reports.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // loads more reports
  void loadMore() {
    if (!hasMore) return;
    visibleCount = (visibleCount + _pageSize).clamp(0, _filteredReports.length);
    notifyListeners();
  }

  // animal filter
  void setAnimalFilter(String? animal) {
    _selectedAnimal = animal;
    _resetPagination();
  }

  // status filter
  void setStatusFilter(String? status) {
    _selectedStatus = status;
    _resetPagination();
  }

  // clear filters
  void clearFilters() {
    _selectedAnimal = null;
    _selectedStatus = null;
    _resetPagination();
  }

  // resets pagination
  void _resetPagination() {
    visibleCount = _filteredReports.length > _pageSize
        ? _pageSize
        : _filteredReports.length;
    notifyListeners();
  }

  // refresh the whole list
  Future<void> refresh() async {
    // optional: show the spinner
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await fetchReports(); 
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
