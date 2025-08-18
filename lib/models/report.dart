import 'package:flutter/foundation.dart';

@immutable
class Report {
  final String id;
  final String title;
  final String status; // 'lost' | 'found'
  final String animal; // 'dog' | 'cat' | 'other'
  final String image;
  final bool isNew;

  const Report({
    required this.id,
    required this.title,
    required this.status,
    required this.animal,
    required this.image,
    required this.isNew,
  });
}