import 'room_addon_amenity.dart';
import 'room_entity.dart';
import 'room_image_entity.dart';

abstract class BrowseRoomDetailEntity {
  BrowseRoomDetailEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.areaSqm,
    required this.monthlyRent,
    required this.depositAmount,
    required this.electricityRatePerKwh,
    required this.waterRatePerM3,
    required this.hasFurniture,
    required this.includedAmenityCodes,
    required this.addonAmenities,
    required this.propertyId,
    required this.propertyName,
    required this.fullAddress,
    required this.landlordName,
    required this.images,
    this.description,
    this.landlordAvatarUrl,
  });

  final String id;
  final String title;
  final RoomStatus status;
  final double areaSqm;
  final double monthlyRent;
  final double depositAmount;
  final double electricityRatePerKwh;
  final double waterRatePerM3;
  final bool hasFurniture;
  final String? description;
  final List<String> includedAmenityCodes;
  final List<RoomAddonAmenity> addonAmenities;
  final String propertyId;
  final String propertyName;
  final String fullAddress;
  final String landlordName;
  final String? landlordAvatarUrl;
  final List<RoomImageEntity> images;
}
