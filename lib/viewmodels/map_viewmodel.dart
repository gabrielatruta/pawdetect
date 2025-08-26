// viewmodels/map_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel(this._reportService);
  final ReportService _reportService;

  // map camera
  LatLng center = const LatLng(46.7712, 23.6236); // Cluj fallback
  double zoom = 12.0;
  bool isLocating = false;

  // selected (for dialog)
  report.Report? selected;

  // zoom-in/out
  static const double minZoom = 3.0;
  static const double maxZoom = 18.0;

  void setZoom(double newZoom) {
    final clamped = newZoom.clamp(minZoom, maxZoom);
    if (clamped != zoom) {
      zoom = clamped;
      notifyListeners();
    }
  }

  void zoomIn() => setZoom(zoom + 1.0);
  void zoomOut() => setZoom(zoom - 1.0);

  void setCenter(LatLng newCenter) {
    if (newCenter != center) {
      center = newCenter;
      notifyListeners();
    }
  }

  // stream of reports with coordinates
  Stream<List<report.Report>> get reports$ =>
      _reportService.streamReportsWithLocation();

  Future<void> init({required bool useLocation}) async {
    if (!useLocation) return;
    isLocating = true;
    notifyListeners();
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (enabled &&
          (perm == LocationPermission.always ||
              perm == LocationPermission.whileInUse)) {
        final pos = await Geolocator.getCurrentPosition();
        center = LatLng(pos.latitude, pos.longitude);
        zoom = 14.0;
      }
    } catch (_) {
      // keep fallback center silently
    } finally {
      isLocating = false;
      notifyListeners();
    }
  }

  void select(report.Report r) {
    selected = r;
    notifyListeners();
  }

  void clearSelection() {
    selected = null;
    notifyListeners();
  }
}
