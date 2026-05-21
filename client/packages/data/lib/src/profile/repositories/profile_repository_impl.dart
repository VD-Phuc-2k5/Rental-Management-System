import 'package:core/errors.dart';
import 'package:domain/profile.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileRemoteDataSource profileRemoteDataSource,
    required String Function() getToken,
  })  : _dataSource = profileRemoteDataSource,
        _getToken = getToken;

  final ProfileRemoteDataSource _dataSource;
  final String Function() _getToken;

  @override
  Future<Either<Failure, UserProfileEntity>> getProfile() async {
    try {
      final data = await _dataSource.getProfile(token: _getToken());
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
  Future<Either<Failure, UserProfileEntity>> updateProfile({
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? avatarUrl,
  }) async {
    try {
      final data = await _dataSource.updateProfile(
        token: _getToken(),
        fullName: fullName,
        phone: phone,
        dateOfBirth: dateOfBirth,
        avatarUrl: avatarUrl,
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
}
