part of 'contract_detail_bloc.dart';

typedef ContractDetailState = SealedClassState<Failure, ContractEntity>;
typedef ContractDetailInitial = SealedClassInitial<Failure, ContractEntity>;
typedef ContractDetailLoadInProgress
    = SealedClassLoadInProgress<Failure, ContractEntity>;
typedef ContractDetailLoadSuccess
    = SealedClassLoadSuccess<Failure, ContractEntity>;
typedef ContractDetailLoadFailure
    = SealedClassLoadFailure<Failure, ContractEntity>;
