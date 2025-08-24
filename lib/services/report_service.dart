import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/models/report_model.dart' as report;

class ReportService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reportsCol =>
      _firestore.collection('reports');

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
    // server timestamps to satisfy Firestore rules
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    if (lat != null) data['lat'] = lat;
    if (lng != null) data['lng'] = lng;

    // a small timeout to avoid UI hanging forever
    await docRef.set(data).timeout(const Duration(seconds: 15));

    return docRef.id;
  }

  Future<void> updateReport(String id, Map<String, dynamic> partial) async {
    partial.remove('userId');
    partial.remove('createdAt');
    partial['updatedAt'] = FieldValue.serverTimestamp();
    await _reportsCol.doc(id).update(partial);
  }
}