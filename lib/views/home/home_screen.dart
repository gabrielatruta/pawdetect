import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawdetect/viewmodels/report/all_reports_viewmodel.dart';
import 'package:pawdetect/viewmodels/home/home_viewmodel.dart';
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

  @override
  Widget build(BuildContext context) {
    context.watch<HomeViewModel>();

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

              Builder(
                builder: (context) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    return const SizedBox.shrink();
                  }

                  final alertsStream = FirebaseFirestore.instance
                      .collection('reports')
                      .where('userId', isEqualTo: user.uid)
                      .where('type', isEqualTo: report.ReportType.lost.value)
                      .where('foundAlertSubscription.enabled', isEqualTo: true)
                      .snapshots();

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: alertsStream,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: LinearProgressIndicator(),
                        );
                      }

                      final Map<report.AnimalType, Set<String>> buckets = {};
                      for (final d in (snap.data?.docs ?? const [])) {
                        final data = d.data();

                        // 'animal' stored as 'Dog'/'Cat'/... -> map to enum
                        final rawAnimal = (data['animal'] ?? '').toString();
                        final animal = report.AnimalType.values.firstWhere(
                          (a) => a.value.toLowerCase() == rawAnimal.toLowerCase(),
                          orElse: () => report.AnimalType.other,
                        );

                        final fs = data['foundAlertSubscription'];
                        final area = (fs is Map ? (fs['area'] ?? '') : '').toString().trim();
                        if (area.isEmpty) continue;

                        buckets.putIfAbsent(animal, () => <String>{}).add(area);
                      }

                      final filters = {
                        for (final e in buckets.entries) e.key: e.value.toList()..sort()
                      };

                      return ReportsFromAreaSection(
                        filtersByAnimal: filters,
                        limit: 4, // show 4, then Load More (+4)
                      );
                    },
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