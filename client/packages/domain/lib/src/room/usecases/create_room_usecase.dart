import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../room.dart';

class CreateRoomParams extends Equatable {
  const CreateRoomParams({
    required this.propertyId,
    required this.title,
    required this.areaSqm,
    required this.monthlyRent,
    required this.depositAmount,
    required this.electricityRatePerKwh,
    required this.waterRatePerM3,
    required this.includedAmenityCodes,
    required this.addonAmenities,
    this.description,
    this.images,
    this.parkingFees,
  });

  final String propertyId;
  final String title;
  final double areaSqm;
  final double monthlyRent;
  final double depositAmount;
  final double electricityRatePerKwh;
  final double waterRatePerM3;
  final List<String> includedAmenityCodes;
  final List<RoomAddonAmenity> addonAmenities;
  final String? description;
  final List<({String url, int sortOrder})>? images;
  final RoomParkingFees? parkingFees;

  @override
  List<Object?> get props => [propertyId, title, areaSqm, monthlyRent, depositAmount, electricityRatePerKwh, waterRatePerM3, includedAmenityCodes, addonAmenities, description, images, parkingFees];
}

class CreateRoomUsecase implements UseCase<RoomEntity, CreateRoomParams> {
  CreateRoomUsecase({required RoomRepository roomRepository}) : _roomRepository = roomRepository;
  final RoomRepository _roomRepository;

  @override
  Future<Either<Failure, RoomEntity>> call(CreateRoomParams params) async {
    return _roomRepository.createRoom(
      propertyId: params.propertyId,
      title: params.title,
      areaSqm: params.areaSqm,
      monthlyRent: params.monthlyRent,
      depositAmount: params.depositAmount,
      electricityRatePerKwh: params.electricityRatePerKwh,
      waterRatePerM3: params.waterRatePerM3,
      includedAmenityCodes: params.includedAmenityCodes,
      addonAmenities: params.addonAmenities,
      description: params.description,
      images: params.images,
      parkingFees: params.parkingFees,
    );
  }
}
