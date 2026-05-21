import 'package:core/errors.dart';
import 'package:domain/room.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/room_remote_data_source.dart';

class RoomRepositoryImpl implements RoomRepository {
  RoomRepositoryImpl({required RoomRemoteDataSource roomRemoteDataSource, required String Function() getToken})
      : _dataSource = roomRemoteDataSource, _getToken = getToken;

  final RoomRemoteDataSource _dataSource;
  final String Function() _getToken;

  @override
  Future<Either<Failure, List<RoomEntity>>> getRooms({required String propertyId}) async {
    try {
      final data = await _dataSource.getRooms(propertyId: propertyId, token: _getToken());
      return Right(data);
    } on ServerException catch (e) { return Left(ServerFailure(message: e.message));
    } on NetworkException { return const Left(NetworkFailure());
    } on UnknownException catch (e) { return Left(UnknownFailure(message: e.message)); }
  }

  @override
  Future<Either<Failure, RoomEntity>> getRoomById({required String id}) async {
    try {
      final data = await _dataSource.getRoomById(id: id, token: _getToken());
      return Right(data);
    } on ServerException catch (e) { return Left(ServerFailure(message: e.message));
    } on NetworkException { return const Left(NetworkFailure());
    } on UnknownException catch (e) { return Left(UnknownFailure(message: e.message)); }
  }

  @override
  Future<Either<Failure, RoomEntity>> createRoom({
    required String propertyId, required String title, required double areaSqm,
    required double monthlyRent, required double depositAmount,
    required double electricityRatePerKwh, required double waterRatePerM3,
    required List<String> includedAmenityCodes,
    required List<RoomAddonAmenity> addonAmenities,
    String? description,
  }) async {
    try {
      final data = await _dataSource.createRoom(
        propertyId: propertyId, token: _getToken(), title: title, areaSqm: areaSqm,
        monthlyRent: monthlyRent, depositAmount: depositAmount,
        electricityRatePerKwh: electricityRatePerKwh, waterRatePerM3: waterRatePerM3,
        includedAmenityCodes: includedAmenityCodes,
        addonAmenities: addonAmenities,
        description: description,
      );
      return Right(data);
    } on ServerException catch (e) { return Left(ServerFailure(message: e.message));
    } on NetworkException { return const Left(NetworkFailure());
    } on UnknownException catch (e) { return Left(UnknownFailure(message: e.message)); }
  }

  @override
  Future<Either<Failure, RoomEntity>> updateRoom({
    required String id, String? title, RoomStatus? status, double? areaSqm,
    double? monthlyRent, double? depositAmount, double? electricityRatePerKwh,
    double? waterRatePerM3,
    List<String>? includedAmenityCodes,
    List<RoomAddonAmenity>? addonAmenities,
    String? description,
  }) async {
    try {
      final statusStr = status != null ? status.name.toUpperCase() : null;
      final data = await _dataSource.updateRoom(
        id: id, token: _getToken(), title: title, status: statusStr,
        areaSqm: areaSqm, monthlyRent: monthlyRent, depositAmount: depositAmount,
        electricityRatePerKwh: electricityRatePerKwh, waterRatePerM3: waterRatePerM3,
        includedAmenityCodes: includedAmenityCodes,
        addonAmenities: addonAmenities,
        description: description,
      );
      return Right(data);
    } on ServerException catch (e) { return Left(ServerFailure(message: e.message));
    } on NetworkException { return const Left(NetworkFailure());
    } on UnknownException catch (e) { return Left(UnknownFailure(message: e.message)); }
  }

  @override
  Future<Either<Failure, void>> deleteRoom({required String id}) async {
    try {
      await _dataSource.deleteRoom(id: id, token: _getToken());
      return const Right(null);
    } on ServerException catch (e) { return Left(ServerFailure(message: e.message));
    } on NetworkException { return const Left(NetworkFailure());
    } on UnknownException catch (e) { return Left(UnknownFailure(message: e.message)); }
  }
}
