import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
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

    // --- Primary path: image_picker (supports iCloud when plugin is up to date) ---
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 2000,
      );
      if (file != null) {
        // read as bytes for preview (this can throw on iCloud-only assets if not downloaded)
        try {
          final bytes = await file.readAsBytes();
          if (!mounted) return;
          setState(() => _bytes = bytes);
        } catch (_) {
          // If preview fails we still pass the file; UI just won't show the preview until later.
        }
        widget.onChanged?.call(file);
        return;
      }
    } on PlatformException catch (e) {
      // Common iOS error when the photo is only in iCloud or permission is limited
      debugPrint('image_picker failed: ${e.code} ${e.message}');
      // We’ll fall back to Files below
    } catch (e, st) {
      debugPrint('image_picker unexpected error: $e\n$st');
      // Fall back below
    }

    // --- Fallback path: Files / iCloud Drive via file_picker ---
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true, // important on iOS
        allowMultiple: false,
      );
      if (res == null || res.files.isEmpty) return;

      final f = res.files.first;
      Uint8List? bytes = f.bytes;

      // Some providers return only a path; load bytes manually if needed
      if (bytes == null && f.path != null) {
        bytes = await XFile(f.path!).readAsBytes();
      }

      if (bytes != null) {
        if (!mounted) return;
        setState(() => _bytes = bytes);

        // Wrap the bytes in an XFile so the rest of your pipeline stays unchanged
        final mime = lookupMimeType(f.name) ?? 'image/jpeg';
        final xf = XFile.fromData(
          bytes,
          name: f.name.isNotEmpty ? f.name : 'image.jpg',
          mimeType: mime,
        );
        widget.onChanged?.call(xf);
        return;
      }
    } catch (e, st) {
      debugPrint('file_picker fallback error: $e\n$st');
    }

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.pick_photo_error_generic)));
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
