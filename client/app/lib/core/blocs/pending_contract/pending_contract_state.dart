part of 'pending_contract_cubit.dart';

sealed class PendingContractState extends Equatable {
  const PendingContractState();
}

class PendingContractNone extends PendingContractState {
  const PendingContractNone();

  @override
  List<Object?> get props => [];
}

class PendingContractFound extends PendingContractState {
  const PendingContractFound(this.contract);

  final ContractEntity contract;

  @override
  List<Object?> get props => [contract];
}
