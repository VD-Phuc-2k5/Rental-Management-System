part of 'contract_detail_bloc.dart';

sealed class ContractDetailEvent {}

class ContractDetailFetched extends ContractDetailEvent {
  ContractDetailFetched({required this.contractId});
  final String contractId;
}
