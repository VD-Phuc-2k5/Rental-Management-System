part of 'get_profile_bloc.dart';

sealed class GetProfileEvent extends Equatable {
  const GetProfileEvent();
  @override
  List<Object> get props => [];
}

final class GetProfileFetched extends GetProfileEvent {
  const GetProfileFetched();
}
