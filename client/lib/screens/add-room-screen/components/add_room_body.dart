import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'room_form_card.dart';
import 'room_list_section.dart';
import 'room_action_buttons.dart';

class AddRoomBody extends StatelessWidget {
  const AddRoomBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const RoomFormCard(),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue700,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppColors.white, size: 16),
                label: const Text(
                  "Thêm phòng",
                  style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w500, fontSize: 16, color: AppColors.white)
                ),
              ),
            ),
            const SizedBox(height: 16),

            const RoomListSection(),
            const SizedBox(height: 16),

            const RoomActionButtons(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}