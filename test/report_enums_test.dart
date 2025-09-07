import 'package:flutter_test/flutter_test.dart';
import 'package:pawdetect/models/report_model.dart' as m;

void main() {
  group('Report enums (pure)', () {
    test('ReportType parse + value', () {
      expect(m.ReportTypeX.parse('Found'), m.ReportType.found);
      expect(m.ReportTypeX.parse('lost'), m.ReportType.lost);
      expect(m.ReportTypeX.parse('???'), m.ReportType.lost);

      expect(m.ReportType.found.value, 'Found');
      expect(m.ReportType.lost.value, 'Lost');
    });

    test('AnimalType parse', () {
      expect(m.AnimalTypeX.parse('dog'), m.AnimalType.dog);
      expect(m.AnimalTypeX.parse('CAT'), m.AnimalType.cat);
      expect(m.AnimalTypeX.parse('iguana'), m.AnimalType.other);
    });

    test('Gender parse', () {
      expect(m.GenderX.parse('F'), m.Gender.female);
      expect(m.GenderX.parse('m'), m.Gender.male);
      expect(m.GenderX.parse('?'), m.Gender.unknown);
      expect(m.GenderX.parse(''), m.Gender.unknown);
    });

    test('FurColor parse', () {
      expect(m.FurColorX.parse('Black'), m.FurColor.black);
      expect(m.FurColorX.parse('white'), m.FurColor.white);
      expect(m.FurColorX.parse('BROWN'), m.FurColor.brown);
      expect(m.FurColorX.parse('gray'), m.FurColor.gray);
      expect(m.FurColorX.parse('golden'), m.FurColor.golden);
      expect(m.FurColorX.parse('cream'), m.FurColor.cream);
      expect(m.FurColorX.parse('orange'), m.FurColor.orange);
      expect(m.FurColorX.parse('brindle'), m.FurColor.brindle);
      expect(m.FurColorX.parse('spotted'), m.FurColor.spotted);
      expect(m.FurColorX.parse('??'), m.FurColor.mixed);
    });

    test('ReportStatus parse + value', () {
      expect(m.ReportStatusX.parse('Solved'), m.ReportStatus.solved);
      expect(m.ReportStatusX.parse('anything'), m.ReportStatus.unsolved);
      expect(m.ReportStatus.solved.value, 'Solved');
      expect(m.ReportStatus.unsolved.value, 'Unsolved');
    });
  });
}
