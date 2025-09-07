import 'package:flutter_test/flutter_test.dart';
import 'package:pawdetect/models/report_model.dart' as m;

class ReportLite {
  final String id;
  final m.ReportType type;
  final m.AnimalType animal;
  final m.ReportStatus status;
  ReportLite(this.id, this.type, this.animal, this.status);
}

Iterable<ReportLite> filter({
  required Iterable<ReportLite> src,
  m.ReportType? type,
  m.AnimalType? animal,
  m.ReportStatus? status,
}) sync* {
  for (final r in src) {
    if (type != null && r.type != type) continue;
    if (animal != null && r.animal != animal) continue;
    if (status != null && r.status != status) continue;
    yield r;
  }
}

void main() {
  test('filters by type + animal + status (pure)', () {
    final data = <ReportLite>[
      ReportLite('1', m.ReportType.lost,  m.AnimalType.dog,  m.ReportStatus.unsolved),
      ReportLite('2', m.ReportType.found, m.AnimalType.dog,  m.ReportStatus.unsolved),
      ReportLite('3', m.ReportType.found, m.AnimalType.cat,  m.ReportStatus.solved),
      ReportLite('4', m.ReportType.lost,  m.AnimalType.cat,  m.ReportStatus.unsolved),
    ];

    final onlyFoundDogs = filter(src: data, type: m.ReportType.found, animal: m.AnimalType.dog).toList();
    expect(onlyFoundDogs.map((e) => e.id), ['2']);

    final onlyUnsolved = filter(src: data, status: m.ReportStatus.unsolved).toList();
    expect(onlyUnsolved.map((e) => e.id), ['1', '2', '4']);
  });

  test('parsers handle mixed case / unknowns (pure)', () {
    expect(m.ReportTypeX.parse('FOUND'), m.ReportType.found);
    expect(m.AnimalTypeX.parse('DoG'), m.AnimalType.dog);
    // Unknown report type defaults to lost in your model:
    expect(m.ReportTypeX.parse('???'), m.ReportType.lost);
  });
}
