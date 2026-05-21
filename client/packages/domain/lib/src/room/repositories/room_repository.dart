import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../../room.dart';

abstract interface class RoomRepository {
  Future<Either<Failure, List<RoomEntity>>> getRooms({required String propertyId});
  Future<Either<Failure, RoomEntity>> getRoomById({required String id});
  Future<Either<Failure, RoomEntity>> createRoom({
    required String propertyId,
    required String title,
    required double areaSqm,
    required double monthlyRent,
    required double depositAmount,
    required double electricityRatePerKwh,
    required double waterRatePerM3,
    required List<String> includedAmenityCodes,
    required List<RoomAddonAmenity> addonAmenities,
    String? description,
  });
  Future<Either<Failure, RoomEntity>> updateRoom({
    required String id,
    String? title,
    RoomStatus? status,
    double? areaSqm,
    double? monthlyRent,
    double? depositAmount,
    double? electricityRatePerKwh,
    double? waterRatePerM3,
    List<String>? includedAmenityCodes,
    List<RoomAddonAmenity>? addonAmenities,
    String? description,
  });
  Future<Either<Failure, void>> deleteRoom({required String id});
}
