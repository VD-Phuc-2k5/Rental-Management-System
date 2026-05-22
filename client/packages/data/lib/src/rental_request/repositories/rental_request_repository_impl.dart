import 'package:core/errors.dart';
import 'package:domain/rental_request.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/rental_request_remote_data_source.dart';

class RentalRequestRepositoryImpl implements RentalRequestRepository {
  RentalRequestRepositoryImpl({
    required RentalRequestRemoteDataSource rentalRequestRemoteDataSource,
    required String Function() getToken,
  })  : _dataSource = rentalRequestRemoteDataSource,
        _getToken = getToken;

  final RentalRequestRemoteDataSource _dataSource;
  final String Function() _getToken;

  @override
  Future<Either<Failure, RentalRequestEntity>> createRentalRequest({
    required String roomId,
    String? note,
  }) async {
    try {
      final data = await _dataSource.createRentalRequest(
        token: _getToken(),
        roomId: roomId,
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
  Future<Either<Failure, List<RentalRequestEntity>>> getMyRentalRequests() async {
    try {
      final data = await _dataSource.getMyRentalRequests(token: _getToken());
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
  Future<Either<Failure, void>> cancelRentalRequest({required String id}) async {
    try {
      await _dataSource.cancelRentalRequest(token: _getToken(), id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<RentalRequestEntity>>> getIncomingRequests() async {
    try {
      final data = await _dataSource.getIncomingRequests(token: _getToken());
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
  Future<Either<Failure, void>> rejectRentalRequest({required String id}) async {
    try {
      await _dataSource.rejectRentalRequest(token: _getToken(), id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<ContractEntity>>> getMyContracts() async {
    try {
      final data = await _dataSource.getMyContracts(token: _getToken());
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
  Future<Either<Failure, List<ContractEntity>>> getLandlordContracts() async {
    try {
      final data = await _dataSource.getLandlordContracts(token: _getToken());
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
  Future<Either<Failure, ContractEntity>> getContractDetail({
    required String id,
  }) async {
    try {
      final data =
          await _dataSource.getContractDetail(token: _getToken(), id: id);
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
  Future<Either<Failure, ContractEntity>> updateContract({
    required String id,
    String? startDate,
    String? endDate,
    double? monthlyRent,
    double? deposit,
    String? terms,
  }) async {
    try {
      final data = await _dataSource.updateContract(
        token: _getToken(),
        id: id,
        startDate: startDate,
        endDate: endDate,
        monthlyRent: monthlyRent,
        deposit: deposit,
        terms: terms,
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
  Future<Either<Failure, void>> sendContract({required String id}) async {
    try {
      await _dataSource.sendContract(token: _getToken(), id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signContract({required String id}) async {
    try {
      await _dataSource.signContract(token: _getToken(), id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cancelContract({required String id}) async {
    try {
      await _dataSource.cancelContract(token: _getToken(), id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> finishContract({required String id}) async {
    try {
      await _dataSource.finishContract(token: _getToken(), id: id);
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
