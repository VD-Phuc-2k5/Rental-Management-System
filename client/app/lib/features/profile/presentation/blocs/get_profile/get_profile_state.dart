part of 'get_profile_bloc.dart';

typedef GetProfileState = SealedClassState<Failure, UserProfileEntity>;
typedef GetProfileInitial = SealedClassInitial<Failure, UserProfileEntity>;
typedef GetProfileLoadInProgress =
    SealedClassLoadInProgress<Failure, UserProfileEntity>;
typedef GetProfileLoadSuccess =
    SealedClassLoadSuccess<Failure, UserProfileEntity>;
typedef GetProfileLoadFailure =
    SealedClassLoadFailure<Failure, UserProfileEntity>;
