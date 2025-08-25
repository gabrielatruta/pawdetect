import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawdetect/views/home/widgets/map/map_report_preview.dart';
import 'package:provider/provider.dart';

import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/map_viewmodel.dart';
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();

    // When the VM updates the center (after geolocation), move the map.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _map.move(vm.center, vm.zoom);
    });

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 260,
        child: FlutterMap(
          mapController: _map,
          options: MapOptions(initialCenter: vm.center, initialZoom: vm.zoom),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.pawdetect.app',
            ),

            // Pins with reports from Firestore
            StreamBuilder<List<report.Report>>(
              stream: vm.reports$,
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox.shrink();
                final markers = <Marker>[];
                for (final r in snap.data!) {
                  final lat = r.lat;
                  final lng = r.lng;
                  if (lat == null || lng == null) continue;
                  markers.add(
                    Marker(
                      point: LatLng(lat, lng),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          vm.select(r);
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => MapReportPreview(
                              reportId: r.id!,
                              data: r,
                              onClosed: vm.clearSelection,
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.location_on,
                          size: 36,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                  );
                }
                return MarkerLayer(markers: markers);
              },
            ),
          ],
        ),
      ),
    );
  }
}