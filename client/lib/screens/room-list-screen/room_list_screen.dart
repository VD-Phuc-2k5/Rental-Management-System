import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

import 'components/room_bottom_nav.dart';
import 'components/room_list_body.dart';

class RoomListScreen extends StatelessWidget {
  const RoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate900),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          "Khu A – 123 Nguyễn Trãi",
          style: TextStyle(
            color: AppColors.slate900,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.slate50,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.slate500,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate200, height: 1.0),
        ),
      ),
      body: const RoomListBody(),
      bottomNavigationBar: const RoomBottomNav(),
    );
  }
}
