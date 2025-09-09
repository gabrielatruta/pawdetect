import 'package:flutter_test/flutter_test.dart';
import 'package:pawdetect/viewmodels/report/report_details_viewmodel.dart';

void main() {
  test('midnight, single-digit parts, end-of-year (pure)', () {
    expect(
      ReportDetailsViewModel.convertDateToString(DateTime(2025, 1, 1, 0, 0)),
      '2025-01-01 00:00',
    );
    expect(
      ReportDetailsViewModel.convertDateToString(DateTime(2024, 2, 3, 4, 5)),
      '2024-02-03 04:05',
    );
    expect(
      ReportDetailsViewModel.convertDateToString(
        DateTime(2024, 12, 31, 23, 59),
      ),
      '2024-12-31 23:59',
    );
  });
}
