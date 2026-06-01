import 'package:core/errors.dart';
import 'package:domain/room.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/browse_room_remote_data_source.dart';

class BrowseRoomRepositoryImpl implements BrowseRoomRepository {
  BrowseRoomRepositoryImpl({
    required BrowseRoomRemoteDataSource browseRoomRemoteDataSource,
    required String Function() getToken,
  })  : _dataSource = browseRoomRemoteDataSource,
        _getToken = getToken;

  final BrowseRoomRemoteDataSource _dataSource;
  final String Function() _getToken;

  @override
  Future<Either<Failure, List<AvailableRoomEntity>>> getAvailableRooms({
    double? minRent,
    double? maxRent,
  }) async {
    try {
      final data = await _dataSource.getAvailableRooms(
        token: _getToken(),
        minRent: minRent,
        maxRent: maxRent,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BrowseRoomDetailEntity>> getRoomDetail({
    required String id,
  }) async {
    try {
      final data = await _dataSource.getRoomDetail(id: id, token: _getToken());
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }
}
