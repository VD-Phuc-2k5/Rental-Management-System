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
    super.memberInfo,
    super.parkingInfo,
    super.roomTitle,
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
        memberInfo: (json['memberInfo'] as List<dynamic>?)
                ?.map((e) => MemberInfo.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        parkingInfo: (json['parkingInfo'] as List<dynamic>?)
                ?.map((e) => VehicleInfo.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        roomTitle: json['roomTitle'] as String?,
      );
}

RentalRequestStatus _statusFromJson(String v) =>
    RentalRequestStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == v.toUpperCase(),
      orElse: () => RentalRequestStatus.pending,
    );
