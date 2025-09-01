import 'package:pawdetect/services/report_service.dart';
import 'package:pawdetect/models/report_model.dart' as report;

class AreaReportsViewModel {
  AreaReportsViewModel({
    required ReportService service,
    required this.animalType,
    required List<String> areas,
  }) : _service = service,
       areas = List.unmodifiable(areas);

  final ReportService _service;
  final String animalType;
  final List<String> areas;

  Stream<List<report.Report>> get reportsStream => _service
      .watchFoundReportsByAnimalAndAreas(animalType: animalType, areas: areas)
      .map(
        (docs) => docs
            .map((d) => report.Report.fromFirestore(d.id, d.data()))
            .toList(),
      );
}
