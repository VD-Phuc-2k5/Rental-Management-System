import 'room_addon_amenity.dart';
import 'room_image_entity.dart';

enum RoomStatus { available, occupied, maintenance }

class RoomParkingFees {
  const RoomParkingFees({
    this.motorbike = 150000,
    this.car = 1000000,
  });

  factory RoomParkingFees.fromJson(Map<String, dynamic> json) =>
      RoomParkingFees(
        motorbike: (json['motorbike'] as num?)?.toDouble() ?? 150000,
        car: (json['car'] as num?)?.toDouble() ?? 1000000,
      );

  final double motorbike;
  final double car;

  Map<String, dynamic> toJson() => {
    'motorbike': motorbike,
    'car': car,
  };
}

abstract class RoomEntity {
  RoomEntity({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.status,
    required this.areaSqm,
    required this.monthlyRent,
    required this.depositAmount,
    required this.electricityRatePerKwh,
    required this.waterRatePerM3,
    required this.includedAmenityCodes,
    required this.addonAmenities,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.images = const [],
    this.parkingFees = const RoomParkingFees(),
  });

  final String id;
  final String propertyId;
  final String title;
  final RoomStatus status;
  final double areaSqm;
  final double monthlyRent;
  final double depositAmount;
  final double electricityRatePerKwh;
  final double waterRatePerM3;
  final List<String> includedAmenityCodes;
  final List<RoomAddonAmenity> addonAmenities;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final List<RoomImageEntity> images;
  final RoomParkingFees parkingFees;
}
