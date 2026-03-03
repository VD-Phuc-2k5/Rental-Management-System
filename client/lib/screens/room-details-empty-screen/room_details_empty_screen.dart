import 'package:app/core/constants.dart';
// 1. Import cái AppBar dùng chung của Phúc
import 'package:app/core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';

import 'components/empty_tenant_state.dart';
import 'components/room_details_bottom_bar.dart';
import 'components/room_info_card.dart';

class RoomDetailsEmptyScreen extends StatelessWidget {
  final String roomNumber;

  const RoomDetailsEmptyScreen({super.key, required this.roomNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: CommonAppBar(title: "Chi tiết phòng $roomNumber"),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  RoomInfoCard(roomNumber: roomNumber),
                  const EmptyTenantState(),
                ],
              ),
            ),
          ),
          const RoomDetailsBottomBar(),
        ],
      ),
    );
  }
}
