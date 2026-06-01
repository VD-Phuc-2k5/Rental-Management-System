part of 'create_viewing_appointment_bloc.dart';

sealed class CreateViewingAppointmentEvent {}

class CreateViewingAppointmentSubmitted extends CreateViewingAppointmentEvent {
  CreateViewingAppointmentSubmitted({
    required this.roomId,
    required this.scheduledAt,
    this.note,
  });

  final String roomId;
  final String scheduledAt;
  final String? note;
}
