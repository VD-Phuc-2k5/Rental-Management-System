import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

import '../../update-room-screen/update_room_screen.dart';

class RoomDetailsBottomBar extends StatelessWidget {
  const RoomDetailsBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.slate200, width: 1.0)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.white,
            side: const BorderSide(color: AppColors.slate300, width: 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UpdateRoomScreen()),
            );
          },
          icon: const Icon(
            Icons.edit_outlined,
            color: AppColors.slate900,
            size: 18,
          ),
          label: const Text(
            "Chỉnh sửa thông tin phòng",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.slate900,
            ),
          ),
        ),
      ),
    );
  }
}
