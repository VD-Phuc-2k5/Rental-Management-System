import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../../auth.dart';
import '../entities/auth_entity.dart';

abstract interface class AuthRepository {
  Stream<AuthEntity?> get onAuthStateChanged;

  Future<Either<Failure, void>> register({
    required String fullName,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    required bool acceptedTerms,
  });

  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();
}
