import 'package:domain/rental_request.dart';

class RentalRequestModel extends RentalRequestEntity {
  RentalRequestModel({
    required super.id,
    required super.tenantId,
    required super.roomId,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.note,
  });

  factory RentalRequestModel.fromJson(Map<String, dynamic> json) =>
      RentalRequestModel(
        id: json['id'] as String,
        tenantId: json['tenantId'] as String,
        roomId: json['roomId'] as String,
        status: _statusFromJson(json['status'] as String),
        note: json['note'] as String?,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
      );
}

RentalRequestStatus _statusFromJson(String v) =>
    RentalRequestStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == v.toUpperCase(),
      orElse: () => RentalRequestStatus.pending,
    );
