import 'package:core/errors.dart';
import 'package:domain/property.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/property_remote_data_source.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  PropertyRepositoryImpl({required PropertyRemoteDataSource propertyRemoteDataSource, required String Function() getToken})
      : _dataSource = propertyRemoteDataSource,
        _getToken = getToken;

  final PropertyRemoteDataSource _dataSource;
  final String Function() _getToken;

  @override
  Future<Either<Failure, List<PropertyEntity>>> getProperties() async {
    try {
      final data = await _dataSource.getProperties(token: _getToken());
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
  Future<Either<Failure, PropertyEntity>> getPropertyById({required String id}) async {
    try {
      final data = await _dataSource.getPropertyById(id: id, token: _getToken());
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
  Future<Either<Failure, PropertyEntity>> createProperty({
    required String name, required String address, required String ward,
    required String district, required String city, required String description,
    required List<String> amenityCodes,
  }) async {
    try {
      final data = await _dataSource.createProperty(
        token: _getToken(), name: name, address: address, ward: ward,
        district: district, city: city, description: description, amenityCodes: amenityCodes,
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
  Future<Either<Failure, PropertyEntity>> updateProperty({
    required String id, String? name, String? address, String? ward,
    String? district, String? city, String? description, List<String>? amenityCodes,
  }) async {
    try {
      final data = await _dataSource.updateProperty(
        id: id, token: _getToken(), name: name, address: address, ward: ward,
        district: district, city: city, description: description, amenityCodes: amenityCodes,
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
  Future<Either<Failure, void>> deleteProperty({required String id}) async {
    try {
      await _dataSource.deleteProperty(id: id, token: _getToken());
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
