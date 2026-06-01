part of 'my_rental_request_list_bloc.dart';

typedef MyRentalRequestListState
    = SealedClassState<Failure, List<RentalRequestEntity>>;
typedef MyRentalRequestListInitial
    = SealedClassInitial<Failure, List<RentalRequestEntity>>;
typedef MyRentalRequestListLoadInProgress
    = SealedClassLoadInProgress<Failure, List<RentalRequestEntity>>;
typedef MyRentalRequestListLoadSuccess
    = SealedClassLoadSuccess<Failure, List<RentalRequestEntity>>;
typedef MyRentalRequestListLoadFailure
    = SealedClassLoadFailure<Failure, List<RentalRequestEntity>>;
