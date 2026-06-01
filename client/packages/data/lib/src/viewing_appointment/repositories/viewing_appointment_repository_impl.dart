import 'package:core/errors.dart';
import 'package:domain/viewing_appointment.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/viewing_appointment_remote_data_source.dart';

class ViewingAppointmentRepositoryImpl implements ViewingAppointmentRepository {
  ViewingAppointmentRepositoryImpl({
    required ViewingAppointmentRemoteDataSource viewingAppointmentRemoteDataSource,
    required String Function() getToken,
  })  : _dataSource = viewingAppointmentRemoteDataSource,
        _getToken = getToken;

  final ViewingAppointmentRemoteDataSource _dataSource;
  final String Function() _getToken;

  @override
  Future<Either<Failure, ViewingAppointmentEntity>> createViewingAppointment({
    required String roomId,
    required String scheduledAt,
    String? note,
  }) async {
    try {
      final data = await _dataSource.createViewingAppointment(
        token: _getToken(),
        roomId: roomId,
        scheduledAt: scheduledAt,
        note: note,
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
  Future<Either<Failure, List<ViewingAppointmentEntity>>>
      getMyViewingAppointments() async {
    try {
      final data =
          await _dataSource.getMyViewingAppointments(token: _getToken());
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
  Future<Either<Failure, List<ViewingAppointmentEntity>>>
      getLandlordViewingAppointments() async {
    try {
      final data = await _dataSource.getLandlordViewingAppointments(
          token: _getToken());
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
  Future<Either<Failure, ViewingAppointmentEntity>> approveViewingAppointment({
    required String id,
  }) async {
    try {
      final data = await _dataSource.approveViewingAppointment(
          token: _getToken(), id: id);
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
  Future<Either<Failure, ViewingAppointmentEntity>> rejectViewingAppointment({
    required String id,
  }) async {
    try {
      final data = await _dataSource.rejectViewingAppointment(
          token: _getToken(), id: id);
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
  Future<Either<Failure, void>> cancelViewingAppointment({
    required String id,
  }) async {
    try {
      await _dataSource.cancelViewingAppointment(token: _getToken(), id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }
}
