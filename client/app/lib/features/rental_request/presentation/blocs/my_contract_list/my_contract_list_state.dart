part of 'my_contract_list_bloc.dart';

typedef MyContractListState = SealedClassState<Failure, List<ContractEntity>>;
typedef MyContractListInitial
    = SealedClassInitial<Failure, List<ContractEntity>>;
typedef MyContractListLoadInProgress
    = SealedClassLoadInProgress<Failure, List<ContractEntity>>;
typedef MyContractListLoadSuccess
    = SealedClassLoadSuccess<Failure, List<ContractEntity>>;
typedef MyContractListLoadFailure
    = SealedClassLoadFailure<Failure, List<ContractEntity>>;
