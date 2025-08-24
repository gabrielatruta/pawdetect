import 'dart:math';
import '/../models/report_model.dart'; // import your model + enums

/// Utility class for generating demo Report objects.
class DemoReports {
  static final _rng = Random();

  /// Generate a list of demo reports.
  static List<Report> generate({int count = 20}) {
    return List.generate(count, (i) => _fakeReport(i));
  }

  /// Generate a single fake report.
  static Report fake(int i) => _fakeReport(i);

  static Report _fakeReport(int i) {
    final isLost = i.isEven;
    final type = isLost ? ReportType.lost : ReportType.found;

    final animal = switch (i % 3) {
      0 => AnimalType.dog,
      1 => AnimalType.cat,
      _ => AnimalType.other,
    };

    final gender = switch (_rng.nextInt(3)) {
      0 => Gender.male,
      1 => Gender.female,
      _ => Gender.unknown,
    };

    final colors = [
      FurColor.values[_rng.nextInt(FurColor.values.length)],
      if (_rng.nextBool())
        FurColor.values[_rng.nextInt(FurColor.values.length)],
    ].toSet().toList();

    final status = (_rng.nextBool())
        ? ReportStatus.solved
        : ReportStatus.unsolved;

    return Report(
      id: 'demo_$i',
      userId: 'user_${i % 5}',
      type: type,
      animal: animal,
      colors: colors,
      gender: gender,
      location: 'Area ${_rng.nextInt(100)}',
      additionalInfo: isLost
          ? 'Lost near park, very friendly.'
          : 'Found wandering around street.',
      photoUrls: [
        'https://placekitten.com/200/20${i % 9}',
        'https://placedog.net/200/20${(i + 3) % 9}',
      ],
      phoneNumber1: '+12345678${i % 10}${_rng.nextInt(9)}',
      phoneNumber2: (i % 4 == 0) ? '+98765432${i % 10}' : '',
      status: status,
      createdAt: DateTime.now().subtract(Duration(days: i)),
      updatedAt: DateTime.now().subtract(Duration(hours: i * 3)),
    );
  }
}
