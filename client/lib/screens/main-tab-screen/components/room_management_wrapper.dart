import 'package:flutter/material.dart';

import '../../empty-room-screen/empty_room_screen.dart';
import '../../room-list-screen/room_list_screen.dart';

class RoomManagementWrapper extends StatefulWidget {
  const RoomManagementWrapper({super.key});

  @override
  State<RoomManagementWrapper> createState() => _RoomManagementWrapperState();
}

class _RoomManagementWrapperState extends State<RoomManagementWrapper> {
  bool hasRooms = true;

  @override
  Widget build(BuildContext context) {
    if (hasRooms) {
      return const RoomListScreen();
    } else {
      return const EmptyRoomScreen();
    }
  }
}
