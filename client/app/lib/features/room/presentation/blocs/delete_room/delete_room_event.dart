part of 'delete_room_bloc.dart';
sealed class DeleteRoomEvent {}
class DeleteRoomSubmitted extends DeleteRoomEvent {
  DeleteRoomSubmitted({required this.id});
  final String id;
}
