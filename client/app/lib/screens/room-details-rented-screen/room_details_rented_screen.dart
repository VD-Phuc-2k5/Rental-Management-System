import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';

import '../room-details-empty-screen/components/room_info_card.dart';
import 'components/contract_info_section.dart';
import 'components/pending_requests_section.dart';
import 'components/rented_room_bottom_bar.dart';
import 'components/tenant_list_section.dart';

class RoomDetailsRentedScreen extends StatelessWidget {
  final String roomNumber;

  const RoomDetailsRentedScreen({super.key, required this.roomNumber});

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
                  const TenantListSection(),
                  const SizedBox(height: 24),
                  RoomInfoCard(roomNumber: roomNumber),
                  const SizedBox(height: 24),
                  const PendingRequestsSection(),
                  const SizedBox(height: 24),
                  const ContractInfoSection(),
                ],
              ),
            ),
          ),
          const RentedRoomBottomBar(),
        ],
      ),
    );
  }
}
