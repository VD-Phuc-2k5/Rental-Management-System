part of 'my_viewing_appointment_list_bloc.dart';

typedef MyViewingAppointmentListState
    = SealedClassState<Failure, List<ViewingAppointmentEntity>>;
typedef MyViewingAppointmentListInitial
    = SealedClassInitial<Failure, List<ViewingAppointmentEntity>>;
typedef MyViewingAppointmentListLoadInProgress
    = SealedClassLoadInProgress<Failure, List<ViewingAppointmentEntity>>;
typedef MyViewingAppointmentListLoadSuccess
    = SealedClassLoadSuccess<Failure, List<ViewingAppointmentEntity>>;
typedef MyViewingAppointmentListLoadFailure
    = SealedClassLoadFailure<Failure, List<ViewingAppointmentEntity>>;
