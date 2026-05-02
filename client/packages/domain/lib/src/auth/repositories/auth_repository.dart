import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../../auth.dart';

abstract interface class AuthRepository {
  Stream<UserEntity?> get onAuthStateChanged;

  Future<Either<Failure, void>> register({
    required String fullName,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    required bool acceptedTerms,
  });

  Future<Either<Failure, void>> logout();
}
