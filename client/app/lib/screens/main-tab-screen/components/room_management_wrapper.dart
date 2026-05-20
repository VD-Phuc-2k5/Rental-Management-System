import 'package:flutter/material.dart';

class RoomManagementWrapper extends StatefulWidget {
  const RoomManagementWrapper({super.key});

  static RoomManagementWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<RoomManagementWrapperState>();
  }

  @override
  State<RoomManagementWrapper> createState() => RoomManagementWrapperState();
}

class RoomManagementWrapperState extends State<RoomManagementWrapper> {
  static bool hasRooms = false;

  void updateState(bool hasRoomData) {
    setState(() {
      hasRooms = hasRoomData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
