part of 'browse_room_detail_bloc.dart';

sealed class BrowseRoomDetailEvent {}

class BrowseRoomDetailFetched extends BrowseRoomDetailEvent {
  BrowseRoomDetailFetched({required this.roomId});
  final String roomId;
}
