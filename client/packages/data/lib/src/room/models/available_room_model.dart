import 'package:domain/room.dart';

class AvailableRoomModel extends AvailableRoomEntity {
  AvailableRoomModel({
    required super.id,
    required super.title,
    required super.status,
    required super.areaSqm,
    required super.monthlyRent,
    required super.depositAmount,
    required super.propertyId,
    required super.propertyName,
    required super.fullAddress,
    super.firstImageUrl,
  });

  factory AvailableRoomModel.fromJson(Map<String, dynamic> json) =>
      AvailableRoomModel(
        id: json['id'] as String,
        title: json['title'] as String,
        status: _statusFromJson(json['status'] as String),
        areaSqm: _parseDouble(json['areaSqm']),
        monthlyRent: _parseDouble(json['monthlyRent']),
        depositAmount: _parseDouble(json['depositAmount']),
        propertyId: json['propertyId'] as String,
        propertyName: json['propertyName'] as String,
        fullAddress: json['fullAddress'] as String,
        firstImageUrl: json['firstImageUrl'] as String?,
      );
}

double _parseDouble(dynamic v) =>
    v is num ? v.toDouble() : double.parse(v.toString());

RoomStatus _statusFromJson(String v) => switch (v.toUpperCase()) {
      'OCCUPIED' => RoomStatus.occupied,
      'MAINTENANCE' => RoomStatus.maintenance,
      _ => RoomStatus.available,
    };
