import 'package:app/core/constants.dart';
import 'package:app/screens/add-room-screen/add_room_screen.dart';
import 'package:app/screens/main-tab-screen/components/room_management_wrapper.dart';
import 'package:flutter/material.dart';

import 'blueprint_illustration.dart';

class EmptyRoomBody extends StatelessWidget {
  const EmptyRoomBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const BlueprintIllustration(),
            const SizedBox(height: 15),
            const Text(
              "Chưa có phòng nào trong\nnhà trọ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 1.33,
                color: AppColors.slate900,
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Bắt đầu quản lý bằng cách thêm các phòng đầu tiên cho khu trọ của bạn.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.62,
                  color: AppColors.slate600,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue700,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddRoomScreen(),
                    ),
                  );

                  if (result == true && context.mounted) {
                    RoomManagementWrapper.of(context)?.updateState(true);
                  }
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  "Thêm khu trọ mới",
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
