import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/styles/app_assets.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/home/widgets/map/map_preview_item.dart';
import 'package:pawdetect/views/reports/report_details_screen.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';
import 'package:provider/provider.dart';

class MapReportPreview extends StatelessWidget {
  final String reportId;
  final report.Report data;
  final VoidCallback onClosed;

  const MapReportPreview({
    super.key,
    required this.reportId,
    required this.data,
    required this.onClosed,
  });

  String? _text(String? v) => (v ?? '').trim().isEmpty ? null : v;

  @override
  Widget build(BuildContext context) {
    final title = '${data.type.value} ${data.animal.value}';
    final location = _text(data.location);
    final phone = _text(
      data.phoneNumber1.isNotEmpty ? data.phoneNumber1 : data.phoneNumber2,
    );
    final info = _text(data.additionalInfo);
    final img = (data.photoUrls.isNotEmpty) ? data.photoUrls.first : '';

    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

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
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.orange,
            ),
          ),

          // image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: (img.isEmpty)
                  ? Image.asset(
                      AppAssets.noPhotoPath,
                      fit: BoxFit.cover,
                    )
                  : Image.network(img, fit: BoxFit.cover),
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
            //location
            if (location != null)
              PreviewItem(icon: Icons.place, text: location),

            //phone
            if (phone != null) ...[
              const SizedBox(height: 8),
              PreviewItem(icon: Icons.phone, text: phone),
            ],

            //description
            if (info != null) ...[
              const SizedBox(height: 8),
              PreviewItem(icon: Icons.article_outlined, text: info),
            ],

            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: SecondaryButton(
                      text: loc.close,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onClosed();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: PrimaryButton(
                      text: loc.open,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onClosed();

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ReportDetailsScreen(reportId: reportId),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
