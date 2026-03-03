import 'package:flutter/material.dart';

import '../../empty-room-screen/empty_room_screen.dart';
import '../../room-list-screen/room_list_screen.dart';

class RoomManagementWrapper extends StatefulWidget {
  const RoomManagementWrapper({super.key});

  static RoomManagementWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<RoomManagementWrapperState>();
  }

  @override
  State<RoomManagementWrapper> createState() => RoomManagementWrapperState();
}

class RoomManagementWrapperState extends State<RoomManagementWrapper> {
  bool hasRooms = false;

  void updateState(bool hasRoomData) {
    setState(() {
      hasRooms = hasRoomData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasRooms) {
      return const RoomListScreen();
    } else {
      return const EmptyRoomScreen();
    }
  }
}
