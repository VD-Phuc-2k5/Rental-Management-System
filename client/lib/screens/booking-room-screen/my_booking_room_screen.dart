import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/core/widgets/tenant_navigation_bottom.dart';
import 'package:app/screens/booking-room-screen/components/my-booking-room/body.dart';
import 'package:flutter/material.dart';

class MyBookingRoomScreen extends StatelessWidget {
  const MyBookingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(title: "Lịch hẹn của tôi"),
      body: const RoomBody(),
      bottomNavigationBar: const TenantNavigationBottom(currentIndex: 1),
    );
  }
}