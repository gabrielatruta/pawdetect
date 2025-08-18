// lib/widgets/add_report_sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// Map + geo
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../styles/app_colors.dart';

/// Call [showAddReportSheet(context)] to open the popup.
Future<void> showAddReportSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddReportSheet(),
  );
}

class _AddReportSheet extends StatefulWidget {
  const _AddReportSheet();
  @override
  State<_AddReportSheet> createState() => _AddReportSheetState();
}

class _AddReportSheetState extends State<_AddReportSheet> {
  // Form state
  String _reportType = 'found'; // 'lost' | 'found'
  String _animal = 'dog';       // 'dog'  | 'cat'   | 'other'
  String _gender = '?';         // 'F' | 'M' | '?'
  final Set<String> _colors = {};
  final _colorsCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _infoCtrl = TextEditingController();
  final _phone1Ctrl = TextEditingController();
  final _phone2Ctrl = TextEditingController();

  // Photos
  final List<XFile> _photos = [];
  final _picker = ImagePicker();

  // Alerts & area
  bool _countryWide = false;
  double _radiusKm = 5; // default 5km, up to 300km
  LatLng? _center;      // map center from address or user tap
  final _map = MapController();
  bool _lookingUp = false;

  @override
  void dispose() {
    _colorsCtrl.dispose();
    _addressCtrl.dispose();
    _infoCtrl.dispose();
    _phone1Ctrl.dispose();
    _phone2Ctrl.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, {Widget? suffix}) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.lightGrey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: AppColors.orange, width: 1.6),
        ),
        suffixIcon: suffix,
      );

  // ---------- Color picker (multi-select dialog)
  Future<void> _openColorPicker() async {
    const all = [
      'Black','White','Brown','Gray','Golden','Cream','Orange','Brindle','Spotted','Mixed'
    ];
    final tmp = Set<String>.from(_colors);
    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: StatefulBuilder(
            builder: (context, setLocal) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select color(s)',
                    style: TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    )),
                const Divider(color: AppColors.border, height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: all.map((c) {
                        final checked = tmp.contains(c);
                        return CheckboxListTile(
                          dense: true,
                          value: checked,
                          onChanged: (v) => setLocal(() {
                            v == true ? tmp.add(c) : tmp.remove(c);
                          }),
                          activeColor: AppColors.orange,
                          title: Text(c, style: const TextStyle(color: AppColors.darkGrey)),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => setLocal(() => tmp.clear()),
                      child: const Text('Clear', style: TextStyle(color: AppColors.lightGrey)),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _colors
                            ..clear()
                            ..addAll(tmp);
                          _colorsCtrl.text = _colors.join(', ');
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.white,
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Image picking
  Future<void> _pickPhoto() async {
    final src = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.orange),
              title: const Text('Choose from Library'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera, color: AppColors.orange),
              title: const Text('Take a Photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.close, color: AppColors.lightGrey),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(ctx, null),
            ),
          ],
        ),
      ),
    );

    if (src == null) return;

    final XFile? file = await _picker.pickImage(
      source: src,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    if (file != null) {
      setState(() => _photos.add(file));
    }
  }

  // ---------- Geolocation helpers
  Future<void> _useMyLocation() async {
    try {
      final ok = await Geolocator.requestPermission();
      if (ok == LocationPermission.deniedForever ||
          ok == LocationPermission.denied) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      setState(() => _center = latLng);
      _map.move(latLng, 13);
    } catch (_) {}
  }

  Future<void> _geocodeAddress() async {
    final q = _addressCtrl.text.trim();
    if (q.isEmpty) return;
    setState(() => _lookingUp = true);
    try {
      final results = await geo.locationFromAddress(q);
      if (results.isNotEmpty) {
        final first = results.first;
        final latLng = LatLng(first.latitude, first.longitude);
        setState(() => _center = latLng);
        _map.move(latLng, 13);
      }
    } finally {
      if (mounted) setState(() => _lookingUp = false);
    }
  }

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
                // Header
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
                          'Add new report',
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

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: LayoutBuilder(
                      builder: (context, c) {
                        final w = c.maxWidth;
                        final gapM = (w * 0.04).clamp(14, 24).toDouble();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Report type
                            const Text('Report type',
                                style: TextStyle(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w700,
                                )),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                ChoiceChip(
                                  label: const Text('Found'),
                                  selected: _reportType == 'found',
                                  onSelected: (_) => setState(() {
                                    _reportType = 'found';
                                  }),
                                  selectedColor: AppColors.orange,
                                  labelStyle: TextStyle(
                                    color: _reportType == 'found'
                                        ? AppColors.white
                                        : AppColors.darkGrey,
                                  ),
                                ),
                                ChoiceChip(
                                  label: const Text('Lost'),
                                  selected: _reportType == 'lost',
                                  onSelected: (_) => setState(() {
                                    _reportType = 'lost';
                                  }),
                                  selectedColor: AppColors.orange,
                                  labelStyle: TextStyle(
                                    color: _reportType == 'lost'
                                        ? AppColors.white
                                        : AppColors.darkGrey,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: gapM),

                            // Animal
                            const Text('Animal',
                                style: TextStyle(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w700,
                                )),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                for (final a in ['dog','cat','other'])
                                  ChoiceChip(
                                    label: Text(a[0].toUpperCase() + a.substring(1)),
                                    selected: _animal == a,
                                    onSelected: (_) => setState(() => _animal = a),
                                    selectedColor: AppColors.orange,
                                    labelStyle: TextStyle(
                                      color: _animal == a ? AppColors.white : AppColors.darkGrey,
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(height: gapM),

                            // Colors (multi-select "dropdown")
                            TextField(
                              controller: _colorsCtrl,
                              readOnly: true,
                              decoration: _dec('Color(s)',
                                  suffix: const Icon(Icons.arrow_drop_down,
                                      color: AppColors.lightGrey)),
                              onTap: _openColorPicker,
                            ),

                            SizedBox(height: gapM),

                            // Gender
                            const Text('Gender',
                                style: TextStyle(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w700,
                                )),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                for (final g in ['F','M','?'])
                                  ChoiceChip(
                                    label: Text(g),
                                    selected: _gender == g,
                                    onSelected: (_) => setState(() => _gender = g),
                                    selectedColor: AppColors.orange,
                                    labelStyle: TextStyle(
                                      color: _gender == g ? AppColors.white : AppColors.darkGrey,
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(height: gapM),

                            // Address (geocode + use my location)
                            TextField(
                              controller: _addressCtrl,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => _geocodeAddress(),
                              decoration: _dec(
                                _reportType == 'lost'
                                    ? 'Where was it lost?'
                                    : 'Where was it found?',
                                suffix: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_lookingUp)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: SizedBox(
                                          width: 16, height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      ),
                                    IconButton(
                                      tooltip: 'Search address',
                                      onPressed: _geocodeAddress,
                                      icon: const Icon(Icons.search, color: AppColors.lightGrey),
                                    ),
                                    IconButton(
                                      tooltip: 'Use my location',
                                      onPressed: _useMyLocation,
                                      icon: const Icon(Icons.my_location, color: AppColors.lightGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // --- Embedded map right under the address ---
                            const SizedBox(height: 12),
                            _MapPicker(
                              controller: _map,
                              center: _center,
                              radiusKm: _countryWide ? null : _radiusKm,
                              onTapMap: (latLng) => setState(() => _center = latLng),
                            ),

                            const SizedBox(height: 12),

                            // Country-wide + Radius
                            CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              value: _countryWide,
                              onChanged: (v) => setState(() => _countryWide = v ?? false),
                              activeColor: AppColors.orange,
                              title: const Text(
                                'Receive alerts for entire country',
                                style: TextStyle(color: AppColors.darkGrey),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),

                            if (!_countryWide) ...[
                              Row(
                                children: [
                                  const Text('Radius', style: TextStyle(color: AppColors.darkGrey)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Slider(
                                      value: _radiusKm,
                                      min: 5,
                                      max: 300,
                                      divisions: 295,
                                      label: '${_radiusKm.toStringAsFixed(0)} km',
                                      onChanged: (v) => setState(() => _radiusKm = v),
                                      activeColor: AppColors.orange,
                                      inactiveColor: AppColors.border,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      '${_radiusKm.toStringAsFixed(0)} km',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(color: AppColors.darkGrey),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            SizedBox(height: gapM),

                            // Extra info
                            TextField(
                              controller: _infoCtrl,
                              maxLines: 4,
                              decoration: _dec('Additional info (distinctive signs, notes)'),
                            ),

                            SizedBox(height: gapM),

                            // Photos
                            const Text('Photos',
                                style: TextStyle(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w700,
                                )),
                            const SizedBox(height: 8),
                            _PhotoGrid(
                              images: _photos,
                              onAdd: _pickPhoto,
                              onRemove: (index) {
                                setState(() => _photos.removeAt(index));
                              },
                            ),

                            SizedBox(height: gapM),

                            // Optional contact
                            const Text('Contact numbers (optional)',
                                style: TextStyle(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w700,
                                )),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _phone1Ctrl,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]')),
                              ],
                              decoration: _dec('Phone number 1'),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _phone2Ctrl,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]')),
                              ],
                              decoration: _dec('Phone number 2'),
                            ),

                            SizedBox(height: gapM),

                            // Actions
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.border),
                                      shape: const StadiumBorder(),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: AppColors.darkGrey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // TODO: save report; persist _center, _radiusKm (or country-wide)
                                      // and the user's push token for targeting later
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.orange,
                                      foregroundColor: AppColors.white,
                                      shape: const StadiumBorder(),
                                      elevation: 0,
                                    ),
                                    child: const Text('Create report'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
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

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  final List<XFile> images;
  final VoidCallback onAdd;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // Add tile
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Icon(Icons.add_a_photo, color: AppColors.lightGrey),
            ),
          ),
        ),
        for (int i = 0; i < images.length; i++)
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 96,
                  height: 96,
                  color: AppColors.surface,
                  alignment: Alignment.center,
                  child: Image.file(
                    File(images[i].path),
                    fit: BoxFit.cover,
                    width: 96,
                    height: 96,
                  ),
                ),
              ),
              Positioned(
                right: -6,
                top: -6,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onRemove(i),
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

// --- Map widget (OpenStreetMap via flutter_map) ---
class _MapPicker extends StatelessWidget {
  const _MapPicker({
    required this.controller,
    required this.center,
    required this.radiusKm,
    required this.onTapMap,
  });

  final MapController controller;
  final LatLng? center;
  final double? radiusKm; // null when country-wide
  final void Function(LatLng) onTapMap;

  @override
  Widget build(BuildContext context) {
    final LatLng fallback = center ?? const LatLng(45.7600, 21.2300); // some sensible default
    final circle = radiusKm == null
        ? null
        : CircleMarker(
            point: center ?? fallback,
            radius: radiusKm! * 1000, // meters
            useRadiusInMeter: true,
            color: AppColors.orange.withOpacity(0.15),
            borderColor: AppColors.orange,
            borderStrokeWidth: 1.5,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 240,
        child: FlutterMap(
          mapController: controller,
          options: MapOptions(
            initialCenter: fallback,
            initialZoom: 12,
            onTap: (tapPos, latLng) => onTapMap(latLng),
          ),
          children: [
            // Free OSM tiles; keep attribution visible
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
              retinaMode: true,
            ),
            if (circle != null)
              CircleLayer(circles: [circle]),
            MarkerLayer(
              markers: [
                Marker(
                  point: center ?? fallback,
                  width: 32,
                  height: 32,
                  child: const Icon(Icons.location_pin, size: 32, color: AppColors.orange),
                ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  '© OpenStreetMap contributors',
                  onTap: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}