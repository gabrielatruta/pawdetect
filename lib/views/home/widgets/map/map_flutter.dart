import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/home/map_viewmodel.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/views/home/widgets/map/map_report_preview.dart';

class MapFlutter extends StatelessWidget {
  final MapController controller;
  final MapViewModel mapViewModel;

  const MapFlutter({
    super.key,
    required this.controller,
    required this.mapViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: mapViewModel.center,
        initialZoom: mapViewModel.zoom,
        onPositionChanged: (pos, _) {
          mapViewModel.onMapMoved(pos.center, pos.zoom);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.pawdetect.app',
        ),

        // Pins with reports from Firestore
        StreamBuilder<List<report.Report>>(
          stream: mapViewModel.reports$,
          builder: (context, snap) {
            if (!snap.hasData) return const SizedBox.shrink();

            final markers = <Marker>[];
            for (final r in snap.data!) {
              final lat = r.lat, lng = r.lng;
              if (lat == null || lng == null) continue;

              markers.add(
                Marker(
                  point: LatLng(lat, lng),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      mapViewModel.select(r);
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => MapReportPreview(
                          reportId: r.id!,
                          data: r,
                          onClosed: mapViewModel.clearSelection,
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
    );
  }
}
