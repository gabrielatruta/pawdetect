import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/home/widgets/map/map_report_preview.dart';

class HomeMapCard extends StatefulWidget {
  final bool useLocation;
  const HomeMapCard({super.key, required this.useLocation});

  @override
  State<HomeMapCard> createState() => _HomeMapCardState();
}

class _HomeMapCardState extends State<HomeMapCard> {
  final _map = MapController();

  // fallbacks if no user location yet
  static const LatLng _fallbackCenter = LatLng(46.7712, 23.6236);
  final LatLng _center = _fallbackCenter;
  final double _zoom = 12.0;

  // get ev
  Stream<QuerySnapshot<Map<String, dynamic>>> get _reports$ => FirebaseFirestore
      .instance
      .collection('reports')
      // simple inequality keeps out docs without 'lat' (no composite index needed)
      .where('lat', isGreaterThan: -90)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 260,
        child: FlutterMap(
          mapController: _map,
          options: MapOptions(initialCenter: _center, initialZoom: _zoom),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.pawdetect.app',
            ),

            // >>> Markers from Firestore
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _reports$,
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox.shrink();

                final markers = <Marker>[];
                for (final doc in snap.data!.docs) {
                  final data = doc.data();
                  final lat = (data['lat'] as num?)?.toDouble();
                  final lng = (data['lng'] as num?)?.toDouble();
                  if (lat == null || lng == null) continue;

                  final point = LatLng(lat, lng);

                  markers.add(
                    Marker(
                      point: point,
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _openReportDialog(doc.id, data),
                        child: const Icon(
                          Icons.location_on,
                          size: 36,
                          color: AppColors.orange, // ORANGE PIN
                        ),
                      ),
                    ),
                  );
                }

                if (markers.isEmpty) return const SizedBox.shrink();
                return MarkerLayer(markers: markers);
              },
            ),
            // <<< Markers
          ],
        ),
      ),
    );
  }

  void _openReportDialog(String id, Map<String, dynamic> data) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => MapReportPreview(reportId: id, data: data),
    );
  }
}
