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
    if (user == null) throw Exception('User not authenticated');

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
      'areaKey': _normalize(alertArea ?? ''),
      'lat': alertLat,
      'lng': alertLng,
    };

    try {
      final _locText =
          (data['location'] ??
                  data['fullAddress'] ??
                  data['address'] ??
                  data['addressText'] ??
                  data['locationText'] ??
                  '')
              .toString()
              .trim();

      final _locKey = _normalize(_locText);
      final _locTokens = _locKey.isEmpty
          ? <String>[]
          : _locKey.split(' ').where((t) => t.isNotEmpty).toSet().toList();

      data['locationKey'] = _locKey;
      data['locationTokens'] = _locTokens;
    } catch (_) {}

    await docRef.set(data).timeout(const Duration(seconds: 15));
    return docRef.id;
  }

  // update a report
  Future<void> updateReport(String id, Map<String, dynamic> partial) async {
    partial.remove('userId');
    partial.remove('createdAt');

    // area keys also updated
    if (partial.containsKey('foundAlertSubscription.area')) {
      final a = (partial['foundAlertSubscription.area'] ?? '').toString();
      partial['foundAlertSubscription.areaKey'] = a.isEmpty
          ? FieldValue.delete()
          : _normalize(a);
    } else if (partial['foundAlertSubscription'] is Map) {
      final fs = Map<String, dynamic>.from(partial['foundAlertSubscription']);
      final a = (fs['area'] ?? '').toString();
      fs['areaKey'] = a.isEmpty ? FieldValue.delete() : _normalize(a);
      partial['foundAlertSubscription'] = fs;
    }

    try {
      if (partial.containsKey('location') ||
          partial.containsKey('fullAddress') ||
          partial.containsKey('address') ||
          partial.containsKey('addressText') ||
          partial.containsKey('locationText')) {
        final _base =
            (partial['location'] ??
                    partial['fullAddress'] ??
                    partial['address'] ??
                    partial['addressText'] ??
                    partial['locationText'] ??
                    '')
                .toString()
                .trim();

        final _lk = _normalize(_base);
        final _lt = _lk.isEmpty
            ? <String>[]
            : _lk.split(' ').where((t) => t.isNotEmpty).toSet().toList();

        partial['locationKey'] = _lk;
        partial['locationTokens'] = _lt;
      }
    } catch (_) {}

    partial['updatedAt'] = FieldValue.serverTimestamp();
    await _reportsCol.doc(id).update(partial);
  }

  // get report by id
  Future<report.Report?> getReportById(String id) async {
    final snap = await _reportsCol.doc(id).get();
    if (!snap.exists) return null;
    return report.Report.fromFirestore(snap.id, snap.data()!);
  }

  // reports with location and status unsolved
  Stream<List<report.Report>> streamReportsWithLocation() {
    return _reportsCol
        .where('status', isEqualTo: report.ReportStatus.unsolved.value)
        .snapshots()
        .map(
          (qs) => qs.docs
              .map((d) => report.Report.fromFirestore(d.id, d.data()))
              .where((r) => r.lat != null && r.lng != null)
              .toList(),
        );
  }

  // watch for reports based on multiple animals and areas for 'reports in area'
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  watchFoundReportsByAnimalAreaFilters({
    required Map<report.AnimalType, List<String>> filters,
    int? limit,
  }) {
    if (filters.isEmpty) return Stream.value(const []);

    // Normalize areas per animal (use areaKey strings from Home)
    final Map<String, List<String>> areasByAnimal = {
      for (final e in filters.entries)
        e.key.name: e.value.map(_normalize).where((s) => s.isNotEmpty).toList(),
    };

    // Build a token set (max 10 for arrayContainsAny)
    final Set<String> tokenSet = {};
    for (final areas in areasByAnimal.values) {
      for (final a in areas) {
        for (final t in a.split(' ')) {
          if (t.isNotEmpty) tokenSet.add(t);
        }
      }
    }
    final tokens = tokenSet.take(10).toList();

    // If we have tokens, narrow server-side with arrayContainsAny; else fall back to type-only query
    Query<Map<String, dynamic>> q = _firestore
        .collection('reports')
        .where('type', isEqualTo: report.ReportType.found.value);

    if (tokens.isNotEmpty) {
      q = q.where('locationTokens', arrayContainsAny: tokens);
    }

    return q.snapshots().map((snap) {
      final docs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

      for (final doc in snap.docs) {
        final data = doc.data();

        // Resolve animal as string name
        final animalStr = (() {
          final raw = data['animal'];
          if (raw is String) return raw.toLowerCase();
          if (raw is int && raw >= 0 && raw < report.AnimalType.values.length) {
            return report.AnimalType.values[raw].name.toLowerCase();
          }
          return '';
        })();

        final wantedAreas = areasByAnimal[animalStr];
        if (wantedAreas == null || wantedAreas.isEmpty) continue;

        final locKey = (data['locationKey'] ?? '').toString();
        if (locKey.isEmpty) continue;

        // Strict-ish check: all tokens of at least one wanted area must be present in locKey
        bool matchesAnyArea = false;
        for (final areaKey in wantedAreas) {
          final tokens = areaKey.split(' ').where((t) => t.isNotEmpty);
          if (tokens.every((t) => locKey.contains(t))) {
            matchesAnyArea = true;
            break;
          }
        }
        if (!matchesAnyArea) continue;

        docs.add(doc);
      }

      // Newest first
      docs.sort((a, b) {
        final ta = a.data()['createdAt'];
        final tb = b.data()['createdAt'];
        final tsa = ta is Timestamp ? ta : Timestamp(0, 0);
        final tsb = tb is Timestamp ? tb : Timestamp(0, 0);
        return tsb.compareTo(tsa);
      });

      if (limit != null && docs.length > limit) {
        return docs.sublist(0, limit);
      }
      return docs;
    });
  }

  String _normalize(String input) {
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
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
