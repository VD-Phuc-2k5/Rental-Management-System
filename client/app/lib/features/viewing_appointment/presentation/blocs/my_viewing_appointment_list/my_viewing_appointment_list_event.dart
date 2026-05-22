part of 'my_viewing_appointment_list_bloc.dart';

sealed class MyViewingAppointmentListEvent {}

class MyViewingAppointmentListFetched extends MyViewingAppointmentListEvent {}

class MyViewingAppointmentCancelled extends MyViewingAppointmentListEvent {
  MyViewingAppointmentCancelled({required this.id});
  final String id;
}
