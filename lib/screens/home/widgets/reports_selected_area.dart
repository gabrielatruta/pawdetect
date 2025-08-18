import 'package:flutter/material.dart';
import '/styles/app_colors.dart';
import '../../../../models/report.dart';

class AreaReportsList extends StatelessWidget {
  const AreaReportsList({
    super.key,
    required this.items,
    required this.showEllipsis,
    required this.onTapMore,
  });

  final List<Report> items;
  final bool showEllipsis;
  final VoidCallback onTapMore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length + (showEllipsis ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          if (showEllipsis && i == items.length) {
            return _MoreCard(onTap: onTapMore);
          }
          final r = items[i];
          final borderColor = r.isNew ? AppColors.orange : AppColors.border;
          final titleColor = r.isNew ? AppColors.orange : AppColors.grey;

          return Container(
            width: 180,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: Container(
                    height: 104,
                    width: double.infinity,
                    color: AppColors.surface,
                    alignment: Alignment.center,
                    child: Image.asset(
                      r.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    r.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MoreCard extends StatelessWidget {
  const _MoreCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            '…',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.lightGrey,
            ),
          ),
        ),
      ),
    );
  }
}