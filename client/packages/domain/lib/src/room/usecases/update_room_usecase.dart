import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../room.dart';

class UpdateRoomParams extends Equatable {
  const UpdateRoomParams({
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

  @override
  List<Object?> get props => [id, title, status, areaSqm, monthlyRent, depositAmount, electricityRatePerKwh, waterRatePerM3, includedAmenityCodes, addonAmenities, description, images, parkingFees];
}

class UpdateRoomUsecase implements UseCase<RoomEntity, UpdateRoomParams> {
  UpdateRoomUsecase({required RoomRepository roomRepository}) : _roomRepository = roomRepository;
  final RoomRepository _roomRepository;

  @override
  Future<Either<Failure, RoomEntity>> call(UpdateRoomParams params) async {
    return _roomRepository.updateRoom(
      id: params.id,
      title: params.title,
      status: params.status,
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
