import 'package:domain/room.dart';

class RoomModel extends RoomEntity {
  RoomModel({
    required super.id,
    required super.propertyId,
    required super.title,
    required super.status,
    required super.areaSqm,
    required super.monthlyRent,
    required super.depositAmount,
    required super.electricityRatePerKwh,
    required super.waterRatePerM3,
    required super.includedAmenityCodes,
    required super.addonAmenities,
    super.description,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    id: json['id'] as String,
    propertyId: json['propertyId'] as String,
    title: json['title'] as String,
    status: _statusFromJson(json['status'] as String),
    areaSqm: _parseDouble(json['area_sqm']),
    monthlyRent: _parseDouble(json['monthly_rent']),
    depositAmount: _parseDouble(json['deposit_amount']),
    electricityRatePerKwh: _parseDouble(json['electricity_rate_per_kwh']),
    waterRatePerM3: _parseDouble(json['water_rate_per_m3']),
    includedAmenityCodes: (json['included_amenity_codes'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    addonAmenities: (json['addon_amenities'] as List<dynamic>?)
            ?.map((e) {
              final m = e as Map<String, dynamic>;
              return RoomAddonAmenity(
                code: m['code'] as String,
                monthlyPrice: _parseDouble(m['monthly_price']),
              );
            })
            .toList() ??
        [],
    description: json['description'] as String?,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

double _parseDouble(dynamic v) =>
    v is num ? v.toDouble() : double.parse(v.toString());

RoomStatus _statusFromJson(String v) => switch (v.toUpperCase()) {
  'OCCUPIED' => RoomStatus.occupied,
  'MAINTENANCE' => RoomStatus.maintenance,
  _ => RoomStatus.available,
};
