import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../profile.dart';

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({
    this.fullName,
    this.phone,
    this.dateOfBirth,
    this.avatarUrl,
  });

  final String? fullName;
  final String? phone;
  final String? dateOfBirth;
  final String? avatarUrl;

  @override
  List<Object?> get props => [fullName, phone, dateOfBirth, avatarUrl];
}

class UpdateProfileUsecase
    implements UseCase<UserProfileEntity, UpdateProfileParams> {
  UpdateProfileUsecase({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  final ProfileRepository _profileRepository;

  @override
  Future<Either<Failure, UserProfileEntity>> call(
    UpdateProfileParams params,
  ) =>
      _profileRepository.updateProfile(
        fullName: params.fullName,
        phone: params.phone,
        dateOfBirth: params.dateOfBirth,
        avatarUrl: params.avatarUrl,
      );
}
