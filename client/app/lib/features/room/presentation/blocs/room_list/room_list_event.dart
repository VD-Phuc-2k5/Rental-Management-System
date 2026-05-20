part of 'room_list_bloc.dart';
sealed class RoomListEvent {}
class RoomListFetched extends RoomListEvent {
  RoomListFetched({required this.propertyId});
  final String propertyId;
}
