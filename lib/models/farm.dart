import 'package:cloud_firestore/cloud_firestore.dart';

class Farm {
  final String farmId;
  final String ownerId;
  final String name;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final String farmType;
  final Map<String, dynamic> stats;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String? deletedBy;

  Farm({
    required this.farmId,
    required this.ownerId,
    required this.name,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    required this.farmType,
    required this.stats,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    this.isDeleted = false,
    this.deletedAt,
    this.deletedBy,
  });

  factory Farm.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Farm(
      farmId: doc.id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      address: data['address'],
      city: data['city'],
      state: data['state'],
      zipCode: data['zipCode'],
      country: data['country'],
      farmType: data['farmType'] ?? 'mixed',
      stats: data['stats'] ?? {},
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
      updatedBy: data['updatedBy'] ?? '',
      isDeleted: data['isDeleted'] ?? false,
      deletedAt: data['deletedAt'] != null
          ? (data['deletedAt'] as Timestamp).toDate()
          : null,
      deletedBy: data['deletedBy'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'farmId': farmId,
      'ownerId': ownerId,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'farmType': farmType,
      'stats': stats,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'deletedBy': deletedBy,
    };
  }

  Farm copyWith({
    String? farmId,
    String? ownerId,
    String? name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? farmType,
    Map<String, dynamic>? stats,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  }) {
    return Farm(
      farmId: farmId ?? this.farmId,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      farmType: farmType ?? this.farmType,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }
}

enum FarmType {
  horses('Horses', 'horses'),
  cattle('Cattle', 'cattle'),
  goats('Goats', 'goats'),
  sheep('Sheep', 'sheep'),
  donkeys('Donkeys', 'donkeys'),
  mixed('Mixed', 'mixed');

  final String label;
  final String value;
  const FarmType(this.label, this.value);
}
