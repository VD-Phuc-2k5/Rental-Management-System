import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../../profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getProfile();
  Future<Either<Failure, UserProfileEntity>> updateProfile({
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? avatarUrl,
  });
}
