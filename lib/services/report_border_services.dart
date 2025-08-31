import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/models/report_model.dart' as models;

/// Rules:
/// - Solved -> green
/// - Not opened yet OR updated since last open -> orange
/// - Opened and not updated -> grey
class ReportBorderService {
  ReportBorderService._();
  static final instance = ReportBorderService._();

  String _key(String uid, String id) => 'seen:$uid:$id';

  Future<Color> colorFor(models.Report r) async {
    // Solved wins
    if (r.status == models.ReportStatus.solved) return AppColors.successGreen;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final id = r.id ?? '';
    if (uid == null || id.isEmpty) return AppColors.border;

    final prefs = await SharedPreferences.getInstance();
    final seenIso = prefs.getString(_key(uid, id));
    final lastOpened = seenIso == null ? null : DateTime.tryParse(seenIso);
    final lastChange =
        (r.updatedAt ?? r.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);

    if (lastOpened == null || lastChange.isAfter(lastOpened)) {
      return AppColors.orange; // new or updated
    }
    return AppColors.border; // opened and not updated
  }

  Future<void> markOpened(String reportId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || reportId.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(uid, reportId), DateTime.now().toIso8601String());
  }
}