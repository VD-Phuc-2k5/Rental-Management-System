import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'components/empty_room_body.dart';
import 'components/room_bottom_nav.dart';

class EmptyRoomScreen extends StatelessWidget {
  const EmptyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate700),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Khu A - 123 Nguyễn Trãi, Q5",
          style: TextStyle(
            color: AppColors.slate900,
            fontFamily: "Public Sans",
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.45,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate200, height: 1.0),
        ),
      ),
      body: const EmptyRoomBody(),
      bottomNavigationBar: const RoomBottomNav(),
    );
  }
}