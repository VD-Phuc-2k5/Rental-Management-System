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
    required this.hasFurniture,
    this.description,
  });

  final String propertyId;
  final String title;
  final double areaSqm;
  final double monthlyRent;
  final double depositAmount;
  final double electricityRatePerKwh;
  final double waterRatePerM3;
  final bool hasFurniture;
  final String? description;

  @override
  List<Object?> get props => [propertyId, title, areaSqm, monthlyRent, depositAmount, electricityRatePerKwh, waterRatePerM3, hasFurniture, description];
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
      hasFurniture: params.hasFurniture,
      description: params.description,
    );
  }
}
