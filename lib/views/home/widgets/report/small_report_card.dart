import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/reports_image.dart';
import '/styles/app_colors.dart';

class SmallReportCard extends StatelessWidget {
  const SmallReportCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.isNew = true,
    this.onTap,
  });

  final String title;
  final String imageUrl;
  final bool isNew;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isNew ? AppColors.orange : AppColors.border;
    final titleColor = isNew ? AppColors.orange : AppColors.grey;
    return SizedBox(
      width: 180,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
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
                  child:
                      ReportsImage(), //aici se pun imaginilleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    title,
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
        ),
      ),
    );
  }
}

//     return SizedBox(
//       width: 180,
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         child: InkWell(
//           onTap: onTap,
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(8),
//             leading: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: SizedBox(width: 56, height: 56, child: ReportsImage()),
//             ),
//             title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
//           ),
//         ),
//       ),
//     );
//   }
// }
