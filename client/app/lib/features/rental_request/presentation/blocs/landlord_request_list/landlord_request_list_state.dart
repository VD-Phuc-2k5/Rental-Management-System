part of 'landlord_request_list_bloc.dart';

typedef LandlordRequestListState
    = SealedClassState<Failure, List<RentalRequestEntity>>;
typedef LandlordRequestListInitial
    = SealedClassInitial<Failure, List<RentalRequestEntity>>;
typedef LandlordRequestListLoadInProgress
    = SealedClassLoadInProgress<Failure, List<RentalRequestEntity>>;
typedef LandlordRequestListLoadSuccess
    = SealedClassLoadSuccess<Failure, List<RentalRequestEntity>>;
typedef LandlordRequestListLoadFailure
    = SealedClassLoadFailure<Failure, List<RentalRequestEntity>>;
