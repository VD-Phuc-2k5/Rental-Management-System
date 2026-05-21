part of 'update_profile_bloc.dart';

sealed class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();
}

final class UpdateProfileSubmitted extends UpdateProfileEvent {
  const UpdateProfileSubmitted({
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
