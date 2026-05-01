import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, void>> register({
    required String fullName,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    required bool acceptedTerms,
  });
}
