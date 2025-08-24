import 'package:flutter/material.dart';
import 'package:pawdetect/views/home/widgets/report/reports_from_area.dart';
import 'package:pawdetect/views/shared/app_logo.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/home_viewmodel.dart';
import '../../../styles/app_colors.dart';
import '/../models/report_model.dart';
import '../reports/demo_report_gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // // Demo data (replace with real data)
  // late final List<Report> _all_reports = DemoReports.generate(count: 36);

  // Filters and pagination
  int _areaShown = 4;

  /// Convert a full [Report] into a [SimpleReport] for UI display.
  SimpleReport _toSimple(Report r) {
    return SimpleReport(
      id: r.id ?? 'unkown',
      title: "${r.type.name.toUpperCase()} ${r.animal.name.toUpperCase()}",
      subtitle: r.location,
      imageUrl: r.photoUrls.isNotEmpty
          ? r.photoUrls.first
          : "https://via.placeholder.com/150",
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<HomeViewModel>();

    // Demo data (replace with ViewModel reports later)
    final reports = DemoReports.generate(count: 20);

    // Map to SimpleReports for ReportsFromArea
    final simpleReports = reports.map(_toSimple).toList();

    final areaSlice = simpleReports.take(_areaShown).toList();
    final areaHasMore = _areaShown < simpleReports.length;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "", showProfileIcon: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            AppLogo(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const Text(
                'Reports in selected area',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGrey,
                  fontSize: 16,
                ),
              ),
            ),
            ReportsFromArea(
              items: areaSlice,
              showLoadMore: areaHasMore,
              onLoadMore: () => setState(() {
                _areaShown = (_areaShown + 4).clamp(0, simpleReports.length);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
