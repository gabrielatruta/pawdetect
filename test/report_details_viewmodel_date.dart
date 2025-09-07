import 'package:flutter_test/flutter_test.dart';
import 'package:pawdetect/viewmodels/report/report_details_viewmodel.dart';

void main() {
  test('convertDateToString formats as YYYY-MM-DD HH:mm (pure)', () {
    final d = DateTime(2025, 1, 9, 7, 5);
    final s = ReportDetailsViewModel.convertDateToString(d);
    expect(s, '2025-01-09 07:05');
  });

  test('convertDateToString pads zeros (pure)', () {
    final d = DateTime(2024, 2, 3, 4, 6);
    final s = ReportDetailsViewModel.convertDateToString(d);
    expect(s, '2024-02-03 04:06');
  });
}
