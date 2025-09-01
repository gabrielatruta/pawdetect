import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pawdetect/views/home/widgets/map/map_flutter.dart';
import 'package:pawdetect/views/home/widgets/map/map_search_bar.dart';
import 'package:pawdetect/views/home/widgets/map/map_suggestions.dart';
import 'package:pawdetect/views/home/widgets/map/map_zoom_controls.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/home/map_viewmodel.dart';
import 'package:pawdetect/services/report_service.dart';

class HomeMapCard extends StatelessWidget {
  final bool useLocation;
  const HomeMapCard({super.key, required this.useLocation});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          MapViewModel(ReportService())..init(useLocation: useLocation),
      child: const _HomeMapView(),
    );
  }
}

class _HomeMapView extends StatefulWidget {
  const _HomeMapView();

  @override
  State<_HomeMapView> createState() => _HomeMapViewState();
}

class _HomeMapViewState extends State<_HomeMapView> {
  final _map = MapController();
  final _searchCtrl = TextEditingController();

  void _moveToVm(MapViewModel mapViewModel) =>
      _map.move(mapViewModel.center, mapViewModel.zoom);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapViewModel = context.watch<MapViewModel>();
    void moveToVm() => _map.move(mapViewModel.center, mapViewModel.zoom);

    // Update map when VM's camera changes (geolocation/search/zoom)
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _moveToVm(mapViewModel),
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 260,
        child: Stack(
          children: [
            // Flutter map
            MapFlutter(controller: _map, mapViewModel: mapViewModel),

            // Search bar
            MapSearchBar(
              controller: _searchCtrl,
              mapViewModel: mapViewModel,
              moveToVm: moveToVm,
            ),

            // Suggestions bar
            if (mapViewModel.suggestions.isNotEmpty)
              MapSuggestions(
                mapViewModel: mapViewModel,
                controller: _searchCtrl,
                moveToVm: moveToVm,
              ),

            // Zoom controls
            MapZoomControls(mapViewModel: mapViewModel, moveToVm: moveToVm),
          ],
        ),
      ),
    );
  }
}
