part of 'update_room_bloc.dart';

sealed class UpdateRoomEvent {}

class UpdateRoomSubmitted extends UpdateRoomEvent {
  UpdateRoomSubmitted({
    required this.id,
    this.title,
    this.status,
    this.areaSqm,
    this.monthlyRent,
    this.depositAmount,
    this.electricityRatePerKwh,
    this.waterRatePerM3,
    this.includedAmenityCodes,
    this.addonAmenities,
    this.description,
    this.images,
    this.parkingFees,
  });
  final String id;
  final String? title;
  final RoomStatus? status;
  final double? areaSqm;
  final double? monthlyRent;
  final double? depositAmount;
  final double? electricityRatePerKwh;
  final double? waterRatePerM3;
  final List<String>? includedAmenityCodes;
  final List<RoomAddonAmenity>? addonAmenities;
  final String? description;
  final List<({String url, int sortOrder})>? images;
  final RoomParkingFees? parkingFees;
}
