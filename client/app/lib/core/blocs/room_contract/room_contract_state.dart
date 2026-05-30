import 'package:equatable/equatable.dart';

abstract class RoomContractState extends Equatable {
  const RoomContractState();
  @override
  List<Object> get props => [];
}

class RoomContractInitial extends RoomContractState {}

class RoomContractLoading extends RoomContractState {}

class RoomContractSuccess extends RoomContractState {
  final String contractId;
  const RoomContractSuccess(this.contractId);
  @override
  List<Object> get props => [contractId];
}

class RoomContractEmpty extends RoomContractState {}

class RoomContractFailure extends RoomContractState {
  final String message;
  const RoomContractFailure(this.message);
  @override
  List<Object> get props => [message];
}