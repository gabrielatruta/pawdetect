import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/reports/widgets/shared/location_field.dart';

class ReceiveNotifications extends StatelessWidget {
  const ReceiveNotifications({
    super.key,
    required this.enabled,
    required this.areaController,
    required this.onEnabledChanged,
    required this.onAreaSelected,
    this.title = 'Receive found alerts',
    this.subtitle =
        'Get notified when a new "Found" report appears in a chosen area.',
    this.helperText =
        'Tip: Choose how broad you want alerts to be:\n'
        '• Whole country (e.g., Romania)\n'
        '• City (e.g., Cluj-Napoca)\n'
        '• Neighbourhood (e.g., Mănăștur)',
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  final bool enabled;
  final TextEditingController areaController;
  final ValueChanged<bool> onEnabledChanged;
  final void Function(String address, double lat, double lng) onAreaSelected;

  final String title;
  final String subtitle;
  final String helperText;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius;

    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: AppColors.darkGrey,
      fontWeight: FontWeight.w600,
    );

    final subStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: AppColors.grey);

    return Card(
      margin: margin,
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          // subtle outline that matches your inputs/dividers
          color: AppColors.grey.withAlpha(64),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: () => onEnabledChanged(!enabled),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // title
                        Text(title, style: titleStyle),
                        const SizedBox(height: 4),

                        //subtitle
                        Text(subtitle, style: subStyle),
                      ],
                    ),
                  ),
                  Switch(
                    value: enabled,
                    onChanged: onEnabledChanged,
                    activeThumbColor: AppColors.orange,
                    inactiveThumbColor: AppColors.lightBackground,
                  ),
                ],
              ),
              if (enabled) ...[
                const SizedBox(height: 12),

                // location for chosen area
                LocationField(
                  controller: areaController,
                  labelText: 'Alert area',
                  onSelected: onAreaSelected,
                ),
                const SizedBox(height: 8),

                // explanatory text
                Text(helperText, style: subStyle),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
