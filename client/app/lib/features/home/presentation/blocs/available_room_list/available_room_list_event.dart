part of 'available_room_list_bloc.dart';

sealed class AvailableRoomListEvent {}

class AvailableRoomListFetched extends AvailableRoomListEvent {
  AvailableRoomListFetched({this.minRent, this.maxRent});
  final double? minRent;
  final double? maxRent;
}
