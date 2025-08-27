import 'package:flutter/material.dart';
import 'package:pawdetect/viewmodels/map_viewmodel.dart';

class MapZoomControls extends StatelessWidget {
  final MapViewModel mapViewModel;
  final VoidCallback moveToVm;

  const MapZoomControls({
    super.key,
    required this.mapViewModel,
    required this.moveToVm,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 10,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: 'mapZoomIn',
            backgroundColor: Colors.orange.shade400,
            onPressed: () {
              mapViewModel.zoomIn();
              moveToVm();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'mapZoomOut',
            backgroundColor: Colors.orange.shade400,
            onPressed: () {
              mapViewModel.zoomOut();
              moveToVm();
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
