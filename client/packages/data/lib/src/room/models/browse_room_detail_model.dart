import 'package:domain/room.dart';

import 'room_image_model.dart';

class BrowseRoomDetailModel extends BrowseRoomDetailEntity {
  BrowseRoomDetailModel({
    required super.id,
    required super.title,
    required super.status,
    required super.areaSqm,
    required super.monthlyRent,
    required super.depositAmount,
    required super.electricityRatePerKwh,
    required super.waterRatePerM3,
    required super.hasFurniture,
    required super.includedAmenityCodes,
    required super.addonAmenities,
    required super.propertyId,
    required super.propertyName,
    required super.fullAddress,
    required super.landlordName,
    required super.images,
    super.description,
    super.landlordAvatarUrl,
  });

  factory BrowseRoomDetailModel.fromJson(Map<String, dynamic> json) =>
      BrowseRoomDetailModel(
        id: json['id'] as String,
        title: json['title'] as String,
        status: _statusFromJson(json['status'] as String),
        areaSqm: _parseDouble(json['areaSqm']),
        monthlyRent: _parseDouble(json['monthlyRent']),
        depositAmount: _parseDouble(json['depositAmount']),
        electricityRatePerKwh: _parseDouble(json['electricityRatePerKwh']),
        waterRatePerM3: _parseDouble(json['waterRatePerM3']),
        hasFurniture: json['hasFurniture'] as bool? ?? false,
        description: json['description'] as String?,
        includedAmenityCodes:
            (json['includedAmenityCodes'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                [],
        addonAmenities: (json['addonAmenities'] as List<dynamic>?)
                ?.map((e) {
                  final m = e as Map<String, dynamic>;
                  return RoomAddonAmenity(
                    code: m['code'] as String,
                    monthlyPrice: _parseDouble(m['monthlyPrice']),
                  );
                })
                .toList() ??
            [],
        propertyId: json['propertyId'] as String,
        propertyName: json['propertyName'] as String,
        fullAddress: json['fullAddress'] as String,
        landlordName: json['landlordName'] as String,
        landlordAvatarUrl: json['landlordAvatarUrl'] as String?,
        images: (json['images'] as List<dynamic>?)
                ?.map((e) =>
                    RoomImageModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

double _parseDouble(dynamic v) =>
    v is num ? v.toDouble() : double.parse(v.toString());

RoomStatus _statusFromJson(String v) => switch (v.toUpperCase()) {
      'OCCUPIED' => RoomStatus.occupied,
      'MAINTENANCE' => RoomStatus.maintenance,
      _ => RoomStatus.available,
    };
