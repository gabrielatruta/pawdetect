import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/models/report_model.dart' as report;

class ReportService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reportsCol =>
      _firestore.collection('reports');

  // create report
  Future<String> createReport({
    required report.ReportType type,
    required report.AnimalType animal,
    required report.Gender gender,
    required List<report.FurColor> colors,
    required String location,
    required String additionalInfo,
    required String phoneNumber1,
    String? phoneNumber2,
    XFile? photo,
    double? lat,
    double? lng,

    // for push notifications
    bool receiveFoundAlerts = false,
    String? alertArea,
    double? alertLat,
    double? alertLng,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final docRef = _reportsCol.doc();

    final newReport = report.Report(
      id: docRef.id,
      userId: user.uid,
      type: type,
      animal: animal,
      colors: colors,
      gender: gender,
      location: location,
      additionalInfo: additionalInfo,
      photoUrls: const [],
      phoneNumber1: phoneNumber1,
      phoneNumber2: phoneNumber2 ?? '',
      status: report.ReportStatus.unsolved,
      createdAt: null,
      updatedAt: null,
    );

    final data = newReport.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    if (lat != null) data['lat'] = lat;
    if (lng != null) data['lng'] = lng;

    data['foundAlertSubscription'] = {
      'enabled': receiveFoundAlerts,
      'area': alertArea ?? '',
      'areaKey': _normalizeArea(alertArea ?? ''),
      'lat': alertLat,
      'lng': alertLng,
    };

    // a small timeout to avoid UI hanging forever
    await docRef.set(data).timeout(const Duration(seconds: 15));

    return docRef.id;
  }

  // update a report
  Future<void> updateReport(String id, Map<String, dynamic> partial) async {
    partial.remove('userId');
    partial.remove('createdAt');

    // keep areaKey in sync if the area is present in partial
    if (partial.containsKey('foundAlertSubscription.area')) {
      final a = (partial['foundAlertSubscription.area'] ?? '').toString();
      if (a.isEmpty) {
        partial['foundAlertSubscription.areaKey'] = FieldValue.delete();
      } else {
        partial['foundAlertSubscription.areaKey'] = _normalizeArea(a);
      }
    }
    
    partial['updatedAt'] = FieldValue.serverTimestamp();
    await _reportsCol.doc(id).update(partial);
  }

  // get report by id
  Future<report.Report?> getReportById(String id) async {
    final snap = await _reportsCol.doc(id).get();
    if (!snap.exists) return null;

    final data = snap.data()!;
    return report.Report.fromFirestore(snap.id, data);
  }

  // streams out reports that do not have a location
  Stream<List<report.Report>> streamReportsWithLocation() {
    return _reportsCol
        .where('lat', isGreaterThan: -90) // filters out docs without coords
        .snapshots()
        .map(
          (qs) => qs.docs
              .map((d) => report.Report.fromFirestore(d.id, d.data()))
              .toList(),
        );
  }

  // rewrites chosen area so they all match the same style (lowercase, without "diacritice", etc.)
  String _normalizeArea(String input) {
    final lower = input.toLowerCase();
    const map = {
      'ă': 'a',
      'â': 'a',
      'á': 'a',
      'à': 'a',
      'ä': 'a',
      'ã': 'a',
      'î': 'i',
      'í': 'i',
      'ì': 'i',
      'ï': 'i',
      'ș': 's',
      'ş': 's',
      'ț': 't',
      'ţ': 't',
      'é': 'e',
      'è': 'e',
      'ë': 'e',
      'ó': 'o',
      'ò': 'o',
      'ö': 'o',
      'õ': 'o',
      'ú': 'u',
      'ù': 'u',
      'ü': 'u',
    };
    final buf = StringBuffer();
    for (final ch in lower.runes.map((r) => String.fromCharCode(r))) {
      buf.write(map[ch] ?? ch);
    }
    return buf
        .toString()
        .replaceAll(RegExp(r'[^a-z0-9\\s]'), ' ')
        .replaceAll(RegExp(r'\\s+'), ' ')
        .trim();
  }
}
