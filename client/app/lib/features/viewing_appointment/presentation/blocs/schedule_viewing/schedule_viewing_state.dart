part of 'schedule_viewing_bloc.dart';

typedef ScheduleViewingState
    = SealedClassState<Failure, ViewingAppointmentEntity>;
typedef ScheduleViewingInitial
    = SealedClassInitial<Failure, ViewingAppointmentEntity>;
typedef ScheduleViewingLoadInProgress
    = SealedClassLoadInProgress<Failure, ViewingAppointmentEntity>;
typedef ScheduleViewingLoadSuccess
    = SealedClassLoadSuccess<Failure, ViewingAppointmentEntity>;
typedef ScheduleViewingLoadFailure
    = SealedClassLoadFailure<Failure, ViewingAppointmentEntity>;
