import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class CloudinaryService {
  static const cloudName = 'dzvcueahh';
  static const unsignedPreset = 'PawDetect';

  static Future<Map<String, dynamic>> uploadXFile(XFile file) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final mimeType = lookupMimeType(file.name) ?? 'image/jpeg';

    final req = http.MultipartRequest('POST', uri)..fields['upload_preset'] = unsignedPreset;

    if (kIsWeb) {
      // Web: XFile.path isn't a real path; use bytes
      final bytes = await file.readAsBytes();
      req.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: file.name,
        contentType: MediaType.parse(mimeType),
      ));
    } else {
      // iOS/Android/desktop
      req.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(mimeType),
      ));
    }

    final res = await req.send();
    final body = await res.stream.bytesToString();
    if (res.statusCode != 200) {
      throw Exception('Cloudinary upload failed (${res.statusCode}): $body');
    }
    return jsonDecode(body) as Map<String, dynamic>;
  }
}
