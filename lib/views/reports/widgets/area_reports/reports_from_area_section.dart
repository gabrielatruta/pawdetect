import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/services/report_service.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/area_reports/load_more_area_reports.dart';
import 'package:pawdetect/views/reports/widgets/area_reports/no_area_reports.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:provider/provider.dart';

class ReportsFromAreaSection extends StatefulWidget {
  const ReportsFromAreaSection({
    super.key,
    required this.filtersByAnimal,
    this.limit = 4,
    this.serviceOverride,
    this.onOpen,
  });

  final Map<report.AnimalType, List<String>> filtersByAnimal;
  final int limit;
  final ReportService? serviceOverride;
  final void Function(report.Report report)? onOpen;

  @override
  State<ReportsFromAreaSection> createState() => _ReportsFromAreaSectionState();
}

class _ReportsFromAreaSectionState extends State<ReportsFromAreaSection> {
  late int _visibleCount;

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>? _stream;

  bool _leavingToDetails = false;
  bool _wasCurrent = true;
  bool _shouldResetOnResume = false;

  static const double _kRowHeight = 190;
  static const double _kSmallCardWidth = 170;

  @override
  void initState() {
    super.initState();
    _visibleCount = widget.limit;
    _buildStreamFor(widget.filtersByAnimal);
  }

  @override
  void didUpdateWidget(covariant ReportsFromAreaSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filtersByAnimal != widget.filtersByAnimal) {
      _visibleCount = widget.limit;
      _buildStreamFor(widget.filtersByAnimal);
    } else if (oldWidget.limit != widget.limit) {
      setState(() => _visibleCount = widget.limit);
    }
  }

  void _buildStreamFor(Map<report.AnimalType, List<String>> filters) {
    if (filters.isEmpty) {
      setState(() => _stream = Stream.value(const []));
      return;
    }
    final service = widget.serviceOverride ?? ReportService();
    _stream = service.watchFoundReportsByAnimalAreaFilters(
      filters: filters,
      limit: null,
    );
    setState(() {});
  }

  void _postBuildRouteWatch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      final isCurrent = route?.isCurrent ?? true;

      if (_wasCurrent && !isCurrent) {
        _shouldResetOnResume = !_leavingToDetails;
      }

      if (!_wasCurrent && isCurrent) {
        if (_shouldResetOnResume) {
          setState(() => _visibleCount = widget.limit);
          _shouldResetOnResume = false;
        }
      }
      _wasCurrent = isCurrent;
    });
  }

  @override
  Widget build(BuildContext context) {
    _postBuildRouteWatch();

    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        margin: EdgeInsets.zero,
        shadowColor: AppColors.orange600,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.grey300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                loc.report_in_area,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.orange,
                ),
              ),
            ),
            const Divider(height: 16, thickness: 0.6),

            if (widget.filtersByAnimal.isEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: NoAreaReports(loc.report_no_area_selected),
              )
            else
              StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: LinearProgressIndicator(),
                    );
                  }
                  final docs = snapshot.data ?? const [];
                  if (docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: NoAreaReports(loc.report_in_area_empty),
                    );
                  }

                  final items = docs
                      .map((d) => report.Report.fromFirestore(d.id, d.data()))
                      .toList();

                  final total = items.length;
                  final visible = math.min(_visibleCount, total);
                  final hasMore = visible < total;

                  return LoadMoreAreaReports(
                    rowHeight: _kRowHeight,
                    smallCardWidth: _kSmallCardWidth,
                    loadMoreWidth: _kSmallCardWidth / 2,
                    items: items,
                    visible: visible,
                    hasMore: hasMore,
                    onLoadMore: () =>
                        setState(() => _visibleCount += widget.limit),
                    onOpen: widget.onOpen,
                    onBeforeOpenDetails: () => _leavingToDetails = true,
                    onAfterCloseDetails: () => _leavingToDetails = false,
                    pageStorageKey: 'areaReportsList',
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
