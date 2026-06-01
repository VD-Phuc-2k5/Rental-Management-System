part of 'create_rental_request_bloc.dart';

typedef CreateRentalRequestState
    = SealedClassState<Failure, RentalRequestEntity>;
typedef CreateRentalRequestInitial
    = SealedClassInitial<Failure, RentalRequestEntity>;
typedef CreateRentalRequestLoadInProgress
    = SealedClassLoadInProgress<Failure, RentalRequestEntity>;
typedef CreateRentalRequestLoadSuccess
    = SealedClassLoadSuccess<Failure, RentalRequestEntity>;
typedef CreateRentalRequestLoadFailure
    = SealedClassLoadFailure<Failure, RentalRequestEntity>;
