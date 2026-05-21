import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../profile.dart';

class GetProfileUsecase implements UseCase<UserProfileEntity, NoParams> {
  GetProfileUsecase({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  final ProfileRepository _profileRepository;

  @override
  Future<Either<Failure, UserProfileEntity>> call(NoParams params) =>
      _profileRepository.getProfile();
}
