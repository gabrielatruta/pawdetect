import 'package:flutter/material.dart';
import '/styles/app_colors.dart';
import '../models/report.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key, required this.items});
  final List<Report> items;

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  int _shown = 10;

  @override
  Widget build(BuildContext context) {
    final shown = widget.items.take(_shown).toList();
    final hasMore = _shown < widget.items.length;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        centerTitle: true,
        title: const Text('My Reports', style: TextStyle(fontWeight: FontWeight.w700)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: shown.length + (hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          if (hasMore && i == shown.length) {
            return OutlinedButton(
              onPressed: () => setState(() {
                _shown = (_shown + 10).clamp(0, widget.items.length);
              }),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.orange),
                shape: const StadiumBorder(),
              ),
              child: const Text('Load more', style: TextStyle(color: AppColors.orange)),
            );
          }

          final r = shown[i];
          final borderColor = r.isNew ? AppColors.orange : AppColors.border;
          final titleColor  = r.isNew ? AppColors.orange : AppColors.darkGrey;

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
                      style: TextStyle(color: titleColor, fontWeight: FontWeight.w600),
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