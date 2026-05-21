part of 'update_profile_bloc.dart';

sealed class UpdateProfileState extends Equatable {
  const UpdateProfileState();
}

final class UpdateProfileInitial extends UpdateProfileState {
  const UpdateProfileInitial();
  @override
  List<Object?> get props => [];
}

final class UpdateProfileLoadInProgress extends UpdateProfileState {
  const UpdateProfileLoadInProgress();
  @override
  List<Object?> get props => [];
}

final class UpdateProfileLoadSuccess extends UpdateProfileState {
  const UpdateProfileLoadSuccess({required this.data});
  final UserProfileEntity data;
  @override
  List<Object?> get props => [data];
}

final class UpdateProfileLoadFailure extends UpdateProfileState {
  const UpdateProfileLoadFailure({required this.failure});
  final Failure failure;
  @override
  List<Object?> get props => [failure];
}
