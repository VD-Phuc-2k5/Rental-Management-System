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
  final List<ContractMemberEntity> members;

  const ContractMembersSuccess(this.members);

  @override
  List<Object> get props => [members];
}

class ContractMembersFailure extends ContractMembersState {
  final String message;

  const ContractMembersFailure(this.message);

  @override
  List<Object> get props => [message];
}
