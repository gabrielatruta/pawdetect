import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/models/report_model.dart' as models;

class ReportBorderService {
  ReportBorderService._();
  static final instance = ReportBorderService._();

  String _key(String uid, String id) => 'seen:$uid:$id';

  DateTime? _toDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is Timestamp) return v.toDate();
    return null;
  }

  Future<Color> colorFor(Object r) async {
    final dyn = r as dynamic;

    // --- required fields pulled via dynamic ---
    final String? id = dyn.id as String?;
    final models.ReportStatus? status = dyn.status as models.ReportStatus?;
    final DateTime? updatedAt = _toDate(dyn.updatedAt);
    final DateTime? createdAt = _toDate(dyn.createdAt);

    // 1) SOLVED ALWAYS WINS (enum from report_model.dart)
    if (status == models.ReportStatus.solved) {
      return AppColors.successGreen;
    }

    // 2) New/updated since last open → ORANGE
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || (id ?? '').isEmpty) return AppColors.border;

    final prefs = await SharedPreferences.getInstance();
    final seenIso = prefs.getString(_key(uid, id!));
    final DateTime? lastOpened = seenIso == null
        ? null
        : DateTime.tryParse(seenIso);

    final lastChange =
        (updatedAt ?? createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);

    if (lastOpened == null || lastChange.isAfter(lastOpened)) {
      return AppColors.orange;
    }

    // 3) Opened and not updated → GREY
    return AppColors.border;
  }

  Future<void> markOpened(String reportId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || reportId.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(uid, reportId),
      DateTime.now().toIso8601String(),
    );
  }
}
