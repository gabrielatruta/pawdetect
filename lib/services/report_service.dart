import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/models/report_model.dart' as report;

class ReportService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

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

    // Optional photo upload (resilient: timeout + fail-open)
    String? photoUrl;
    if (photo != null) {
      try {
        final Uint8List bytes = await photo.readAsBytes();
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${photo.name}'.replaceAll(' ', '_');
        final path = 'reports/${user.uid}/${docRef.id}/$fileName';

        final task = _storage.ref(path).putData(
              bytes,
              SettableMetadata(contentType: _guessContentType(photo)),
            );

        // if upload takes too long, skip the photo and still save the report
        final snapshot =
            await task.timeout(const Duration(seconds: 25)); // <- timeout
        photoUrl = await snapshot.ref.getDownloadURL();
      } on TimeoutException {
        // continue without photo
        // (optionally write a log entry document or analytics event)
      } catch (e) {
        // continue without photo
      }
    }

    final newReport = report.Report(
      id: docRef.id,
      userId: user.uid,
      type: type,
      animal: animal,
      colors: colors,
      gender: gender,
      location: location,
      additionalInfo: additionalInfo,
      photoUrls: photoUrl != null ? [photoUrl] : const [],
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

    // Firestore writes are usually quick; add a small timeout to avoid UI hanging forever
    await docRef.set(data).timeout(const Duration(seconds: 15));

    return docRef.id;
  }

  String _guessContentType(XFile f) {
    final lower = f.name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.heic') || lower.endsWith('.heif')) return 'image/heic';
    return 'image/jpeg';
  }
}
