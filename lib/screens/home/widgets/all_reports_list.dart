import 'package:flutter/material.dart';
import '/styles/app_colors.dart';
import '../../../../models/report.dart';

class AllReportsList extends StatelessWidget {
  const AllReportsList({
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length + (showEllipsis ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        if (showEllipsis && i == items.length) {
          return GestureDetector(
            onTap: onTapMore,
            child: Container(
              height: 82,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                '…',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightGrey,
                ),
              ),
            ),
          );
        }

        final r = items[i];
        final borderColor = r.isNew ? AppColors.orange : AppColors.border;
        final titleColor = r.isNew ? AppColors.orange : AppColors.grey;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
                child: Image.asset(
                  r.image,
                  width: 96,
                  height: 82,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
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
              ),
            ],
          ),
        );
      },
    );
  }
}