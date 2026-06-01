part of 'create_viewing_appointment_bloc.dart';

typedef CreateViewingAppointmentState
    = SealedClassState<Failure, ViewingAppointmentEntity>;
typedef CreateViewingAppointmentInitial
    = SealedClassInitial<Failure, ViewingAppointmentEntity>;
typedef CreateViewingAppointmentLoadInProgress
    = SealedClassLoadInProgress<Failure, ViewingAppointmentEntity>;
typedef CreateViewingAppointmentLoadSuccess
    = SealedClassLoadSuccess<Failure, ViewingAppointmentEntity>;
typedef CreateViewingAppointmentLoadFailure
    = SealedClassLoadFailure<Failure, ViewingAppointmentEntity>;
