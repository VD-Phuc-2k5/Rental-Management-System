import 'package:equatable/equatable.dart';

abstract class RoomContractState extends Equatable {
  const RoomContractState();
  @override
  List<Object> get props => [];
}

class RoomContractInitial extends RoomContractState {}

class RoomContractLoading extends RoomContractState {}

class RoomContractSuccess extends RoomContractState {
  const RoomContractSuccess(this.contractId);
  final String contractId;
  @override
  List<Object> get props => [contractId];
}

class RoomContractEmpty extends RoomContractState {}

class RoomContractFailure extends RoomContractState {
  const RoomContractFailure(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
