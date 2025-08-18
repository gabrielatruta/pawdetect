import 'package:flutter/material.dart';
import '/styles/app_colors.dart';

class MapWithPins extends StatelessWidget {
  const MapWithPins({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    // Placeholder box — swap for a real GoogleMap / flutter_map later.
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
          ),
          const Positioned(left: 24, top: 24, child: Icon(Icons.location_on, color: AppColors.orange, size: 28)),
          const Positioned(right: 36, top: 48, child: Icon(Icons.location_on, color: AppColors.lightGrey, size: 26)),
          const Positioned(left: 80, bottom: 28, child: Icon(Icons.location_on, color: AppColors.orange, size: 30)),
          const Positioned(right: 64, bottom: 36, child: Icon(Icons.location_on, color: AppColors.lightGrey, size: 26)),
          const Center(child: Text('Map preview (pins)', style: TextStyle(color: AppColors.lightGrey))),
        ],
      ),
    );
  }
}