part of 'landlord_viewing_appointment_list_bloc.dart';

sealed class LandlordViewingAppointmentListEvent {}

class LandlordViewingAppointmentListFetched
    extends LandlordViewingAppointmentListEvent {}

class LandlordViewingAppointmentApproved
    extends LandlordViewingAppointmentListEvent {
  LandlordViewingAppointmentApproved({required this.id});
  final String id;
}

class LandlordViewingAppointmentRejected
    extends LandlordViewingAppointmentListEvent {
  LandlordViewingAppointmentRejected({required this.id});
  final String id;
}
