import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/booking-room-screen/components/body.dart';
import 'package:flutter/material.dart';

class BookingRoomScreen extends StatelessWidget {
  const BookingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(title: "Đặt lịch xem phòng"),
      body: const Center(
        child: BookingRoomBody(),
      ),
    );
  }
}