import 'package:equatable/equatable.dart';
import 'package:domain/rental_request.dart';

abstract class ContractMembersState extends Equatable {
  const ContractMembersState();

  @override
  List<Object> get props => [];
}

class ContractMembersInitial extends ContractMembersState {}

class ContractMembersLoading extends ContractMembersState {}

class ContractMembersSuccess extends ContractMembersState {
  const ContractMembersSuccess(this.members);
  final List<ContractMemberEntity> members;

  @override
  List<Object> get props => [members];
}

class ContractMembersFailure extends ContractMembersState {
  const ContractMembersFailure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
