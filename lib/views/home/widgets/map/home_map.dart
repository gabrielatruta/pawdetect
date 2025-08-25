// views/home/widgets/home/home_map.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
      create: (_) => MapViewModel(ReportService())..init(useLocation: useLocation),
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

            // Markers from VM/Firestore
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
                            builder: (_) => _SimpleReportDialog(
                              reportId: r.id!,
                              data: r,
                              onClosed: vm.clearSelection,
                            ),
                          );
                        },
                        child: const Icon(Icons.location_on, size: 36, color: AppColors.orange),
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

/// Simple centered dialog with image (if present) + essential info
class _SimpleReportDialog extends StatelessWidget {
  final String reportId;
  final report.Report data;
  final VoidCallback onClosed;
  const _SimpleReportDialog({required this.reportId, required this.data, required this.onClosed});

  String? _text(String? v) => (v ?? '').trim().isEmpty ? null : v;

  @override
  Widget build(BuildContext context) {
    final title = '${data.type.value} ${data.animal.value}';
    final location = _text(data.location);
    final phone    = _text(data.phoneNumber1.isNotEmpty ? data.phoneNumber1 : data.phoneNumber2);
    final info     = _text(data.additionalInfo);

    ImageProvider? image;
    if (data.photoUrls.isNotEmpty) image = NetworkImage(data.photoUrls.first);

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(image: image, width: 84, height: 84, fit: BoxFit.cover),
            ),
          if (image != null) const SizedBox(height: 12),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.orange)),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (location != null) _InfoLine(icon: Icons.place, text: location),
            if (phone != null) ...[
              const SizedBox(height: 8),
              _InfoLine(icon: Icons.phone, text: phone),
            ],
            if (info != null) ...[
              const SizedBox(height: 8),
              _InfoLine(icon: Icons.info, text: info),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () { Navigator.of(context).pop(); onClosed(); },
          style: TextButton.styleFrom(foregroundColor: AppColors.orange),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.orange),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.3, color: AppColors.darkGrey))),
      ],
    );
  }
}