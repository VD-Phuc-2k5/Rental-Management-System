import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/core/widgets/primary_button.dart';
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: PrimaryButton(
          label: "Xác nhận đặt phòng",
          onPressed: () {
            // TODO: Implement booking confirmation logic
          },
        )
      ),
    );
  }
}