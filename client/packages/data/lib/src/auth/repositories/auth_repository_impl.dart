import 'dart:async';

import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource authRemoteDataSource})
    : _authRemoteDataSource = authRemoteDataSource;

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Stream<AuthEntity?> get onAuthStateChanged {
    final controller = StreamController<AuthEntity?>();

    final subscription = _authRemoteDataSource.onAuthStateChanged.listen(
      (userModel) {
        controller.add(userModel);
      },
      onError: (error) {
        print('Auth Steam Error: $error');
        controller.add(null);
      },
    );

    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }

  @override
  Future<Either<Failure, void>> register({
    required String fullName,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    required bool acceptedTerms,
  }) async {
    try {
      await _authRemoteDataSource.register(
        fullName: fullName,
        password: password,
        confirmPassword: confirmPassword,
        email: email,
        phone: phone,
        acceptedTerms: acceptedTerms,
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

  @override
  Future<Either<Failure, void>> registerLandlord({
    required String identityNumber,
    required String fullName,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    required bool acceptedTerms,
  }) async {
    try {
      await _authRemoteDataSource.registerLandlord(
        identityNumber: identityNumber,
        fullName: fullName,
        password: password,
        confirmPassword: confirmPassword,
        email: email,
        phone: phone,
        acceptedTerms: acceptedTerms,
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

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await _authRemoteDataSource.login(
        email: email,
        password: password,
      );

      return Right(data);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _authRemoteDataSource.logout();
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await _authRemoteDataSource.forgotPassword(
        email: email,
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

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _authRemoteDataSource.verifyOtp(
        email: email,
        otp: otp,
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

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _authRemoteDataSource.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
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
