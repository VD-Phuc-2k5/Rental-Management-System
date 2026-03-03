import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

import 'components/empty_tenant_state.dart';
import 'components/room_details_bottom_bar.dart';
import 'components/room_info_card.dart';

class RoomDetailsEmptyScreen extends StatelessWidget {
  const RoomDetailsEmptyScreen({super.key});

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
          "Chi tiết phòng 302",
          style: TextStyle(
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
        child: Column(children: const [RoomInfoCard(), EmptyTenantState()]),
      ),
      bottomNavigationBar: const RoomDetailsBottomBar(),
    );
  }
}
