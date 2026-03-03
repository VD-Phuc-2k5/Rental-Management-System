import 'package:app/core/constants.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate900),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(
          "Chi tiết phòng $roomNumber",
          style: const TextStyle(
            color: AppColors.slate900,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate100, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
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
      bottomNavigationBar: const RentedRoomBottomBar(),
    );
  }
}
