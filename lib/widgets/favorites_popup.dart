import 'package:flutter/material.dart';
import '/models/report.dart';
import '/styles/app_colors.dart';

Future<void> showFavoritesSheet(
  BuildContext context, {
  required List<Report> initial,
  required ValueChanged<Report> onRemove,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FavoritesSheet(initial: initial, onRemove: onRemove),
  );
}

class _FavoritesSheet extends StatefulWidget {
  const _FavoritesSheet({required this.initial, required this.onRemove});
  final List<Report> initial;
  final ValueChanged<Report> onRemove;

  @override
  State<_FavoritesSheet> createState() => _FavoritesSheetState();
}

class _FavoritesSheetState extends State<_FavoritesSheet> {
  late final List<Report> _items = widget.initial;
  int _shown = 4;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: viewInsets),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 0.95 * 900),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Favourites',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: AppColors.white),
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    itemCount: (_items.length < _shown ? _items.length : _shown) +
                        (_shown < _items.length ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final hasMore = _shown < _items.length;
                      if (hasMore && index == _shown) {
                        return _MoreRow(
                          onTap: () => setState(() {
                            _shown = (_shown + 4).clamp(0, _items.length);
                          }),
                        );
                      }

                      final r = _items[index];
                      return _FavoriteCard(
                        report: r,
                        onUnfavourite: () {
                          setState(() {
                            _items.removeAt(index);
                            _shown = _shown.clamp(0, _items.length);
                          });
                          widget.onRemove(r);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.report, required this.onUnfavourite});
  final Report report;
  final VoidCallback onUnfavourite;

  @override
  Widget build(BuildContext context) {
    final borderColor = report.isNew ? AppColors.orange : AppColors.border;
    final titleColor  = report.isNew ? AppColors.orange : AppColors.grey;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: AppColors.surface,
                  alignment: Alignment.center,
                  child: Image.asset(
                    report.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onUnfavourite,
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: AppColors.orange, size: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              report.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: titleColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreRow extends StatelessWidget {
  const _MoreRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
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
}
