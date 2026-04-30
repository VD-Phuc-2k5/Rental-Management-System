import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource authRemoteDataSource})
    : _authRemoteDataSource = authRemoteDataSource;

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<Either<Failure, void>> register({
    required String fullName,
    required String password,
    required String email,
    required String phone,
  }) async {
    try {
      await _authRemoteDataSource.register(
        fullName: fullName,
        password: password,
        email: email,
        phone: phone,
      );

      return const Right(null);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }
}
