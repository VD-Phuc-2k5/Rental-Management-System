part of 'schedule_viewing_bloc.dart';

sealed class ScheduleViewingEvent {}

class ScheduleViewingSubmitted extends ScheduleViewingEvent {
  ScheduleViewingSubmitted({
    required this.roomId,
    required this.scheduledAt,
    this.note,
  });

  final String roomId;
  final String scheduledAt;
  final String? note;
}
