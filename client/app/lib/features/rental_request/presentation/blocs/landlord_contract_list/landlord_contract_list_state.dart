part of 'landlord_contract_list_bloc.dart';

typedef LandlordContractListState
    = SealedClassState<Failure, List<ContractEntity>>;
typedef LandlordContractListInitial
    = SealedClassInitial<Failure, List<ContractEntity>>;
typedef LandlordContractListLoadInProgress
    = SealedClassLoadInProgress<Failure, List<ContractEntity>>;
typedef LandlordContractListLoadSuccess
    = SealedClassLoadSuccess<Failure, List<ContractEntity>>;
typedef LandlordContractListLoadFailure
    = SealedClassLoadFailure<Failure, List<ContractEntity>>;
