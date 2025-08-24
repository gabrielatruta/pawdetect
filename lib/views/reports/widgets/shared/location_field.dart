// lib/pawdetect/views/shared/location_field.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawdetect/styles/app_colors.dart';

class LocationField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String address, double lat, double lng) onSelected;
  final String? country;
  final String labelText;

  const LocationField({
    super.key,
    required this.controller,
    required this.onSelected,
    this.country,
    this.labelText = 'Location',
  });

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  final _focusNode = FocusNode();
  final _debounceMs = 300;
  Timer? _debounce;
  bool _loading = false;
  List<_Place> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) setState(() => _suggestions = []);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: _debounceMs), () => _search(q));
  }

  Future<void> _search(String q) async {
    if (!mounted) return;
    q = q.trim();
    if (q.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    setState(() => _loading = true);
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': q,
      'format': 'jsonv2',
      'addressdetails': '1',
      'limit': '6',
      if (widget.country != null) 'countrycodes': widget.country!.toLowerCase(),
    });

    try {
      final res = await http.get(
        uri,
        headers: {
          // Identify your app per Nominatim policy:
          'User-Agent': 'pawdetect/1.0 (contact: you@example.com)',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final List data = json.decode(res.body) as List;
        final items = data.map((e) => _Place.fromJson(e)).toList();
        if (!mounted) return;
        setState(() => _suggestions = items);
      } else {
        if (!mounted) return;
        setState(() => _suggestions = []);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _suggestions = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _select(_Place p) {
    widget.controller.text = p.displayName;
    widget.onSelected(p.displayName, p.lat, p.lon);
    setState(() => _suggestions = []);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: _onChanged,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            label: RichText(
              text: TextSpan(
                text: widget.labelText,
                style: const TextStyle(color: Colors.black),
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: AppColors.lightBackground,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.place),
          ),
        ),
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black),
            ),
            constraints: const BoxConstraints(maxHeight: 220),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final s = _suggestions[i];
                return ListTile(
                  dense: true,
                  title: Text(s.title),
                  subtitle: Text(s.subtitle ?? ''),
                  onTap: () => _select(s),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _Place {
  final String displayName;
  final double lat;
  final double lon;

  _Place({required this.displayName, required this.lat, required this.lon});

  String get title {
    // first part before comma for a compact title
    final idx = displayName.indexOf(',');
    return idx == -1 ? displayName : displayName.substring(0, idx);
  }

  String? get subtitle {
    final idx = displayName.indexOf(',');
    return idx == -1 ? null : displayName.substring(idx + 1).trim();
  }

  factory _Place.fromJson(Map<String, dynamic> json) => _Place(
    displayName: json['display_name'] as String,
    lat: double.parse(json['lat'] as String),
    lon: double.parse(json['lon'] as String),
  );
}
