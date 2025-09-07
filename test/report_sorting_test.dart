import 'package:flutter_test/flutter_test.dart';
import 'package:pawdetect/models/report_model.dart' as m;

class ReportLite {
  final m.ReportType type;
  final m.AnimalType animal;
  final DateTime createdAt;
  final String id;
  ReportLite(this.id, this.type, this.animal, this.createdAt);
}

int compareReports(ReportLite a, ReportLite b) {
  // Newest first
  final c = b.createdAt.compareTo(a.createdAt);
  if (c != 0) return c;
  // Tiebreakers (stable & deterministic)
  final t = a.type.index.compareTo(b.type.index);
  if (t != 0) return t;
  final an = a.animal.index.compareTo(b.animal.index);
  if (an != 0) return an;
  return a.id.compareTo(b.id);
}

void main() {
  test('sorts by createdAt desc with stable tiebreakers (pure)', () {
    final base = DateTime(2025, 1, 10, 12, 0);
    final items = <ReportLite>[
      ReportLite('C', m.ReportType.lost,  m.AnimalType.cat,  base.subtract(const Duration(minutes: 2))),
      ReportLite('A', m.ReportType.found, m.AnimalType.dog,  base),
      ReportLite('B', m.ReportType.found, m.AnimalType.dog,  base), 
      ReportLite('D', m.ReportType.found, m.AnimalType.other,base.subtract(const Duration(minutes: 1))),
    ];

    items.sort(compareReports);

    expect(items.map((e) => e.id).toList(), ['A', 'B', 'D', 'C']);
  });
}
