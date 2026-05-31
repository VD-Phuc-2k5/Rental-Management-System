import 'package:equatable/equatable.dart';

abstract class RemoveMemberState extends Equatable {
  const RemoveMemberState();

  @override
  List<Object> get props => [];
}

class RemoveMemberInitial extends RemoveMemberState {}

class RemoveMemberLoading extends RemoveMemberState {}

class RemoveMemberSuccess extends RemoveMemberState {}

class RemoveMemberFailure extends RemoveMemberState {
  const RemoveMemberFailure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
