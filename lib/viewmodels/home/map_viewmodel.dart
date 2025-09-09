import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';

class MapViewModel extends ChangeNotifier {
  // Create once, keep a stable stream instance
  MapViewModel(ReportService reportService)
    : reports$ = reportService.streamReportsWithLocation();

  // Single shared stream used by the UI
  final Stream<List<report.Report>> reports$;

  // map camera
  LatLng center = const LatLng(46.7712, 23.6236); // Cluj fallback
  double zoom = 12.0;
  bool isLocating = false;

  // selected - used for the report preview for pins
  report.Report? selected;

  // zoom-in/out limits
  static const double minZoom = 3.0;
  static const double maxZoom = 18.0;

  void onMapMoved(LatLng c, double z) {
    // single notify for center+zoom
    final nz = z.clamp(minZoom, maxZoom);
    if (center != c || zoom != nz) {
      center = c;
      zoom = nz;
      notifyListeners();
    }
  }

  void setZoom(double newZoom) {
    final clamped = newZoom.clamp(minZoom, maxZoom);
    if (clamped != zoom) {
      zoom = clamped;
      notifyListeners();
    }
  }

  void zoomIn() => setZoom(zoom + 1.0);
  void zoomOut() => setZoom(zoom - 1.0);

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

  // ------ SEARCH ------
  List<PlaceSuggestion> suggestions = [];
  Timer? _debounce;

  void onQueryChanged(String raw) {
    _debounce?.cancel();
    final q = raw.trim();
    if (q.isEmpty) {
      suggestions = [];
      notifyListeners();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _fetchSuggestions(q);
    });
  }

  Future<void> _fetchSuggestions(String q) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': q,
      'format': 'jsonv2',
      'addressdetails': '1',
      'limit': '5',
    });
    final res = await http.get(
      uri,
      headers: {'User-Agent': 'pawdetect/1.0 (map search suggestions)'},
    );
    if (res.statusCode != 200) return;
    final data = jsonDecode(res.body);
    if (data is! List) return;
    suggestions = data
        .map<PlaceSuggestion>((e) => PlaceSuggestion.fromJson(e))
        .toList();
    notifyListeners();
  }

  Future<void> applySuggestion(PlaceSuggestion s) async {
    center = LatLng(s.lat, s.lon);
    zoom = 15.0;
    suggestions = [];
    notifyListeners();
  }

  Future<void> searchPlace(String q) async {
    final query = q.trim();
    if (query.isEmpty) return;
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'jsonv2',
      'limit': '1',
    });
    final res = await http.get(
      uri,
      headers: {'User-Agent': 'pawdetect/1.0 (map search single)'},
    );
    if (res.statusCode != 200) return;
    final data = jsonDecode(res.body);
    if (data is! List || data.isEmpty) return;
    final s = PlaceSuggestion.fromJson(data.first);
    await applySuggestion(s);
  }

  void clearSuggestions() {
    if (suggestions.isNotEmpty) {
      suggestions = [];
      notifyListeners();
    }
  }
}

// location suggestions
class PlaceSuggestion {
  final String title;
  final String subtitle;
  final double lat;
  final double lon;

  PlaceSuggestion({
    required this.title,
    required this.subtitle,
    required this.lat,
    required this.lon,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> j) {
    final display = (j['display_name'] ?? '').toString();
    final parts = display.split(',').map((s) => s.trim()).toList();
    final title = (j['name'] ?? (parts.isNotEmpty ? parts.first : ''))
        .toString();
    final subtitle = parts.length > 1 ? parts.sublist(1).join(', ') : '';
    return PlaceSuggestion(
      title: title,
      subtitle: subtitle,
      lat: double.tryParse('${j['lat']}') ?? 0,
      lon: double.tryParse('${j['lon']}') ?? 0,
    );
  }
}
