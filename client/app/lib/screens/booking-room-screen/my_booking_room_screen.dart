import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';
import '../../core/widgets/tenant_navigation_bottom.dart';
import 'components/my-booking-room/body.dart';
import 'package:flutter/material.dart';

class MyBookingRoomScreen extends StatelessWidget {
  const MyBookingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(title: "Lịch hẹn của tôi"),
      body: RoomBody(),
      bottomNavigationBar: TenantNavigationBottom(currentIndex: 1),
    );
  }
}