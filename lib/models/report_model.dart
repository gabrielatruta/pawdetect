import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Pet report model stored in Firestore.
@immutable
class Report {
  final String? id;                // Firestore doc id
  final String userId;             // who created it
  final ReportType type;           // Found / Lost
  final AnimalType animal;         // Dog / Cat / Other
  final List<FurColor> colors;     // allowed set below
  final Gender gender;             // F / M / ?
  final String location;           // address/area text
  final String additionalInfo;     // notes
  final List<String> photoUrls;    // image URLs
  final String phoneNumber1;       // primary contact number
  final String phoneNumber2;       // secondary contact number (optional)
  final ReportStatus status;       // Solved / Unsolved
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Report({
    this.id,
    required this.userId,
    required this.type,
    required this.animal,
    this.colors = const [],
    this.gender = Gender.unknown,
    this.location = '',
    this.additionalInfo = '',
    this.photoUrls = const [],
    this.phoneNumber1 = '',
    this.phoneNumber2 = '',
    this.status = ReportStatus.unsolved,
    this.createdAt,
    this.updatedAt,
  });

  Report copyWith({
    String? id,
    String? userId,
    ReportType? type,
    AnimalType? animal,
    List<FurColor>? colors,
    Gender? gender,
    String? location,
    String? additionalInfo,
    List<String>? photoUrls,
    String? phoneNumber1,
    String? phoneNumber2,
    ReportStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      animal: animal ?? this.animal,
      colors: colors ?? this.colors,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      photoUrls: photoUrls ?? this.photoUrls,
      phoneNumber1: phoneNumber1 ?? this.phoneNumber1,
      phoneNumber2: phoneNumber2 ?? this.phoneNumber2,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Serialize for Firestore.
  Map<String, dynamic> toMap() => {
        'userId': userId,
        'type': type.value,
        'animal': animal.value,
        'colors': colors.map((c) => c.value).toList(),
        'gender': gender.value,
        'location': location,
        'additionalInfo': additionalInfo,
        'photoUrls': photoUrls,
        'phoneNumber1': phoneNumber1,
        'phoneNumber2': phoneNumber2,
        'status': status.value,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  /// Create from Firestore document data.
  factory Report.fromFirestore(String id, Map<String, dynamic> data) {
    DateTime? _toDate(dynamic v) {
      if (v == null) return null;
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      return null;
    }

    final List colorsRaw = (data['colors'] as List?) ?? const [];
    final List photosRaw = (data['photoUrls'] as List?) ?? const [];

    return Report(
      id: id,
      userId: (data['userId'] as String?) ?? '',
      type: ReportTypeX.parse(data['type']),
      animal: AnimalTypeX.parse(data['animal']),
      colors: colorsRaw.map((e) => FurColorX.parse(e)).toList(),
      gender: GenderX.parse(data['gender']),
      location: (data['location'] as String?) ?? '',
      additionalInfo: (data['additionalInfo'] as String?) ?? '',
      photoUrls: photosRaw.map((e) => e.toString()).toList(),
      phoneNumber1: (data['phoneNumber1'] as String?) ?? '',
      phoneNumber2: (data['phoneNumber2'] as String?) ?? '',
      status: ReportStatusX.parse(data['status']),
      createdAt: _toDate(data['createdAt']),
      updatedAt: _toDate(data['updatedAt']),
    );
  }
}

/// Found / Lost
enum ReportType { found, lost }
extension ReportTypeX on ReportType {
  String get value => switch (this) {
        ReportType.found => 'Found',
        ReportType.lost => 'Lost',
      };
  static ReportType parse(dynamic v) =>
      (v?.toString().toLowerCase() == 'found') ? ReportType.found : ReportType.lost;
}

/// Dog / Cat / Other
enum AnimalType { dog, cat, other }
extension AnimalTypeX on AnimalType {
  String get value => switch (this) {
        AnimalType.dog => 'Dog',
        AnimalType.cat => 'Cat',
        AnimalType.other => 'Other',
      };
  static AnimalType parse(dynamic v) {
    final s = (v ?? '').toString().toLowerCase();
    return s == 'dog' ? AnimalType.dog : s == 'cat' ? AnimalType.cat : AnimalType.other;
  }
}

/// F / M / ?
enum Gender { female, male, unknown }
extension GenderX on Gender {
  String get value => switch (this) {
        Gender.female => 'F',
        Gender.male => 'M',
        Gender.unknown => '?',
      };
  static Gender parse(dynamic v) {
    final s = (v ?? '').toString().toUpperCase();
    return s == 'F' ? Gender.female : s == 'M' ? Gender.male : Gender.unknown;
  }
}

/// Allowed colors: Black, White, Brown, Gray, Golden, Cream, Orange, Brindle, Spotted, Mixed
enum FurColor { black, white, brown, gray, golden, cream, orange, brindle, spotted, mixed }
extension FurColorX on FurColor {
  String get value => switch (this) {
        FurColor.black => 'Black',
        FurColor.white => 'White',
        FurColor.brown => 'Brown',
        FurColor.gray => 'Gray',
        FurColor.golden => 'Golden',
        FurColor.cream => 'Cream',
        FurColor.orange => 'Orange',
        FurColor.brindle => 'Brindle',
        FurColor.spotted => 'Spotted',
        FurColor.mixed => 'Mixed',
      };
  static FurColor parse(dynamic v) {
    final s = (v ?? '').toString().toLowerCase();
    switch (s) {
      case 'black': return FurColor.black;
      case 'white': return FurColor.white;
      case 'brown': return FurColor.brown;
      case 'gray':
      case 'grey':  return FurColor.gray;
      case 'golden': return FurColor.golden;
      case 'cream':  return FurColor.cream;
      case 'orange': return FurColor.orange;
      case 'brindle': return FurColor.brindle;
      case 'spotted': return FurColor.spotted;
      default: return FurColor.mixed;
    }
  }
}

/// Solved / Unsolved
enum ReportStatus { solved, unsolved }
extension ReportStatusX on ReportStatus {
  String get value => switch (this) {
        ReportStatus.solved => 'Solved',
        ReportStatus.unsolved => 'Unsolved',
      };
  static ReportStatus parse(dynamic v) {
    final s = (v ?? '').toString().toLowerCase();
    return s == 'solved' ? ReportStatus.solved : ReportStatus.unsolved;
  }
}