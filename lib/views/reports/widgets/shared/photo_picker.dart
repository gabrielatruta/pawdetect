import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';

class PhotoPicker extends StatefulWidget {
  final ValueChanged<XFile?>? onChanged;
  const PhotoPicker({super.key, this.onChanged});

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  final _picker = ImagePicker();
  Uint8List? _bytes; // for preview

  Future<void> _pick() async {
    final loc = AppLocalizations.of(context)!; // localized strings

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text(loc.pick_photo_gallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(loc.pick_photo_camera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _bytes = bytes;
    });
    widget.onChanged?.call(file);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_bytes != null)
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.black),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.memory(_bytes!, fit: BoxFit.cover),
          ),
        if (_bytes != null) const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.photo),
            label: Text(
              _bytes == null ? loc.pick_photo : loc.pick_photo_change,
            ),
            onPressed: _pick,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.black,
              backgroundColor: AppColors.lightBackground,
              side: const BorderSide(color: AppColors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}
