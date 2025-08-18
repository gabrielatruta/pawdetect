import 'package:flutter/material.dart';
import '/styles/app_colors.dart';
import '../../models/report.dart';
import '/widgets/filter_popup.dart';
import '/widgets/favorites_popup.dart';
import '/screens/add_report_screen.dart';
import '../my_reports_screen.dart';
import '/screens/home/widgets/search_bar.dart';
import '/screens/home/widgets/reports_selected_area.dart';
import '/screens/home/widgets/all_reports_list.dart';
import '/screens/home/widgets/map_with_pins.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Filters
  FilterOptions _filters = FilterOptions.all;

  // Pagination
  int _areaShown = 4;
  int _newShown = 4;

  // Demo data (replace with real data)
  late final List<Report> _all = List.generate(36, (i) {
    final lost = i.isEven;
    final animal = (i % 3 == 0) ? 'dog' : (i % 3 == 1) ? 'cat' : 'other';
    return Report(
      id: 'r$i',
      title: lost ? 'Lost $animal' : 'Found $animal',
      status: lost ? 'lost' : 'found',
      animal: animal,
      image: 'web/icons/welcomeScreenPaw.png',
      isNew: i % 4 == 0,
    );
  });

  // Favourites / My reports (UI-only demos)
  late final List<Report> _favorites = _all.where((r) => r.status == 'found').take(10).toList();
  late final List<Report> _myReports = _all.where((r) => r.status == 'lost').take(12).toList();

  // Helpers
  bool _animalPass(Report r) =>
      (r.animal == 'dog' && _filters.dog) ||
      (r.animal == 'cat' && _filters.cat) ||
      (r.animal == 'other' && _filters.other);

  List<Report> get _filtered => _all.where((r) {
    if (r.status == 'lost' && !_filters.lost) return false;
    if (r.status == 'found' && !_filters.found) return false;
    if (!_animalPass(r)) return false;
    return true;
  }).toList();

  // Actions
  Future<void> _openFilters() async {
    final res = await showFilterDialog(context, _filters);
    if (res != null) {
      setState(() {
        _filters   = res;
        _areaShown = 4;
        _newShown  = 4;
      });
    }
  }

  void _openFavorites() {
    showFavoritesSheet(
      context,
      initial: List<Report>.from(_favorites),
      onRemove: (r) => setState(() => _favorites.removeWhere((e) => e.id == r.id)),
    );
  }

  void _openMyReportsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MyReportsScreen(items: _myReports)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const headerRadius = 28.0;
    final w = MediaQuery.of(context).size.width;
    final gapS = (w * 0.02).clamp(8, 16).toDouble();
    final gapM = (w * 0.04).clamp(14, 24).toDouble();
    final mapHeight = (w * 0.62).clamp(220, 340).toDouble();

    // Build sorted slices
    final areaFoundSorted = _all
        .where((r) => r.status == 'found' && _animalPass(r))
        .toList()
      ..sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));

    final areaHasMore = _areaShown < areaFoundSorted.length;
    final areaSlice   = areaFoundSorted.take(_areaShown).toList();

    final newSorted = [..._filtered]
      ..sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
    final newHasMore = _newShown < newSorted.length;
    final newSlice   = newSorted.take(_newShown).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        centerTitle: true,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(headerRadius)),
        ),
        clipBehavior: Clip.antiAlias,
        // LEFT: profile → open full page via popup button or direct
        leading: IconButton(
          icon: const Icon(Icons.person_outline),
          color: AppColors.white,
          onPressed: _openMyReportsPage, // quick access to full "My reports" page
          tooltip: 'My reports',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            color: AppColors.white,
            onPressed: _openFavorites,
            tooltip: 'Favourites',
          ),
        ],
        title: const Text(''),
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => showAddReportSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: AppColors.white,
              minimumSize: const Size.fromHeight(52),
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: const Text('Add new report'),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, gapM, 16, gapS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeSearchBar(),
            SizedBox(height: gapM),

            const Text(
              'Reports in selected area',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.darkGrey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: gapS),

            AreaReportsList(
              items: areaSlice,
              showEllipsis: areaHasMore,
              onTapMore: () => setState(() {
                _areaShown = (_areaShown + 4).clamp(0, areaFoundSorted.length);
              }),
            ),

            SizedBox(height: gapM),

            MapWithPins(height: mapHeight),

            SizedBox(height: gapM),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'New Reports',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _openFilters,
                  icon: const Icon(Icons.filter_list, size: 18, color: AppColors.orange),
                  label: const Text('Filter', style: TextStyle(color: AppColors.orange)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.orange),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
                  ),
                ),
              ],
            ),
            SizedBox(height: gapS),

            AllReportsList(
              items: newSlice,
              showEllipsis: newHasMore,
              onTapMore: () => setState(() {
                _newShown = (_newShown + 4).clamp(0, newSorted.length);
              }),
            ),

            SizedBox(height: gapM + 72),
          ],
        ),
      ),
    );
  }
}