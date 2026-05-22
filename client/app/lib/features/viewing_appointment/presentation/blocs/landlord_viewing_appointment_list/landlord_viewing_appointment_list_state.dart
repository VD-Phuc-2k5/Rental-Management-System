part of 'landlord_viewing_appointment_list_bloc.dart';

typedef LandlordViewingAppointmentListState
    = SealedClassState<Failure, List<ViewingAppointmentEntity>>;
typedef LandlordViewingAppointmentListInitial
    = SealedClassInitial<Failure, List<ViewingAppointmentEntity>>;
typedef LandlordViewingAppointmentListLoadInProgress
    = SealedClassLoadInProgress<Failure, List<ViewingAppointmentEntity>>;
typedef LandlordViewingAppointmentListLoadSuccess
    = SealedClassLoadSuccess<Failure, List<ViewingAppointmentEntity>>;
typedef LandlordViewingAppointmentListLoadFailure
    = SealedClassLoadFailure<Failure, List<ViewingAppointmentEntity>>;
