import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/reports/widgets/shared/location_field.dart';

class ReceiveNotifications extends StatelessWidget {
  const ReceiveNotifications({
    super.key,
    required this.enabled,
    required this.areaController,
    required this.onEnabledChanged,
    required this.onAreaSelected,
    this.title,
    this.subtitle,
    this.helperText,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  final bool enabled;
  final TextEditingController areaController;
  final ValueChanged<bool> onEnabledChanged;
  final void Function(String address, double lat, double lng) onAreaSelected;

  final String? title;
  final String? subtitle;
  final String? helperText;

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final titleText = title ?? loc.alerts_receive;
    final subtitleTxt = subtitle ?? loc.alerts_subtitle;
    final helperTxt = helperText ?? loc.alerts_helper;

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
        side: BorderSide(color: AppColors.grey.withAlpha(64), width: 1),
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
                        Text(titleText, style: titleStyle),
                        const SizedBox(height: 4),
                        Text(subtitleTxt, style: subStyle),
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
                LocationField(
                  controller: areaController,
                  labelText: loc.alerts_area,
                  onSelected: onAreaSelected,
                ),
                const SizedBox(height: 8),
                Text(helperTxt, style: subStyle),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
