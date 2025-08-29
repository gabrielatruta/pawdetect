import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pawdetect/viewmodels/all_reports_viewmodel.dart';
import 'package:pawdetect/viewmodels/home_viewmodel.dart';
import 'package:pawdetect/views/home/home_map.dart';
import 'package:pawdetect/views/home/widgets/home_bottom_navigation.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/all_reports_form.dart';
import 'package:pawdetect/views/reports/widgets/area_reports/reports_from_area_section.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import '../../../styles/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final bool useLocation;
  const HomeScreen({super.key, bool? useLocation})
      : useLocation = useLocation ?? false;

  // Build filters {AnimalType: [areas]} from the user's LOST reports with alerts on
  Future<Map<report.AnimalType, List<String>>> _loadMyAlertFilters() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final qs = await FirebaseFirestore.instance
        .collection('reports')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: report.ReportType.lost.value) // 'Lost'
        .where('foundAlertSubscription.enabled', isEqualTo: true)
        .get();

    final Map<report.AnimalType, Set<String>> temp = {};
    for (final d in qs.docs) {
      final data = d.data();

      final rawAnimal = (data['animal'] ?? '').toString(); // 'Dog'/'Cat'/...
      final animal = report.AnimalType.values.firstWhere(
        (a) => a.value.toLowerCase() == rawAnimal.toLowerCase(),
        orElse: () => report.AnimalType.other,
      );

      final fs = data['foundAlertSubscription'];
      final area = (fs is Map ? (fs['area'] ?? '') : '').toString().trim();
      if (area.isEmpty) continue;

      temp.putIfAbsent(animal, () => <String>{}).add(area);
    }

    return {for (final e in temp.entries) e.key: e.value.toList()..sort()};
  }

  @override
  Widget build(BuildContext context) {
    context.watch<HomeViewModel>(); // keep if used elsewhere

    return ChangeNotifierProvider(
      create: (_) => AllReportsViewModel()..fetchReports(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(title: "", showProfileIcon: true),
        bottomNavigationBar: const HomeBottomNavigation(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // ONE aggregated section ABOVE the map
              FutureBuilder<Map<report.AnimalType, List<String>>>(
                future: _loadMyAlertFilters(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: LinearProgressIndicator(),
                    );
                  }
                  final filters =
                      snap.data ?? <report.AnimalType, List<String>>{};
                  return ReportsFromAreaSection(
                    filtersByAnimal: filters,
                    limit: 8,
                  );
                },
              ),

              const SizedBox(height: 8),
              HomeMapCard(useLocation: useLocation),
              const SizedBox(height: 16),
              const AllReportsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
