import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawdetect/styles/app_colors.dart';

class HomeMapCard extends StatefulWidget {
  final bool useLocation;
  const HomeMapCard({super.key, required this.useLocation});

  @override
  State<HomeMapCard> createState() => _HomeMapCardState();
}

class _HomeMapCardState extends State<HomeMapCard> {
  static const LatLng _clujCenter = LatLng(46.7712, 23.6236);
  final MapController _map = MapController();
  LatLng _center = _clujCenter;
  final double _zoom = 13;

  @override
  void initState() {
    super.initState();
    if (widget.useLocation) _initLocation();
  }

  @override
  void didUpdateWidget(covariant HomeMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.useLocation != oldWidget.useLocation) {
      if (widget.useLocation) {
        // turned ON -> try to center on user
        _initLocation();
      } else {
        // turned OFF -> snap back to Cluj
        setState(() => _center = _clujCenter);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _map.move(_center, _zoom);
        });
      }
    }
  }

  Future<void> _initLocation() async {
    final center = await _getCenterOrFallback();
    if (!mounted) return;
    setState(() => _center = center);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _map.move(_center, _zoom);
    });
  }

  Future<LatLng> _getCenterOrFallback() async {
    try {
      final servicesOn = await Geolocator.isLocationServiceEnabled();
      var status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied ||
          status == LocationPermission.deniedForever ||
          !servicesOn) {
        return _clujCenter; // don't request here; consent gating happens earlier
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      return _clujCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 240,
        child: FlutterMap(
          mapController: _map,
          options: MapOptions(initialCenter: _center, initialZoom: _zoom),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.pawdetect.app',
            ),
          ],
        ),
      ),
    );
  }
}
