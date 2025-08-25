import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';

class MapReportPreview extends StatelessWidget {
  final String reportId;
  final Map<String, dynamic> data;
  const MapReportPreview({
    super.key,
    required this.reportId,
    required this.data,
  });

  String? _text(dynamic v) {
    final s = (v ?? '').toString().trim();
    return s.isEmpty ? null : s;
  }

  ImageProvider _imageProvider() {
    final photos = (data['photoUrls'] as List?)?.cast<String>() ?? const [];
    if (photos.isNotEmpty) return NetworkImage(photos.first);

    if (kIsWeb) return const NetworkImage('web/icons/placeholder.jpeg');
    return const AssetImage('web/icons/placeholder.jpeg');
  }

  @override
  Widget build(BuildContext context) {
    final type = report.ReportTypeX.parse(data['type']).value;
    final animal = report.AnimalTypeX.parse(data['animal']).value;

    final location = _text(data['location']);
    final phone = _text(data['phoneNumber1'] ?? data['phone']);
    final info = _text(data['additionalInfo']);

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          // title
          Text(
            '$type $animal',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.orange,
            ),
          ),

          // picture
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: _imageProvider(),
              width: 84,
              height: 84,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // location
            if (location != null) _InfoLine(icon: Icons.place, text: location),

            //phone
            if (phone != null) ...[
              const SizedBox(height: 8),
              _InfoLine(icon: Icons.phone, text: phone),
            ],

            // information
            if (info != null) ...[
              const SizedBox(height: 8),
              _InfoLine(icon: Icons.info, text: info),
            ],
          ],
        ),
      ),
      actions: [
        SecondaryButton(
          text: "Close",
          onPressed: () => Navigator.of(context).pop(),
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
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.3,
              color: AppColors.darkGrey,
            ),
          ),
        ),
      ],
    );
  }
}
