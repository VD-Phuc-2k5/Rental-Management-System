import 'package:app/screens/booking-room-screen/components/card_title.dart';
import 'package:flutter/material.dart';

class BookingRoomBody extends StatelessWidget {
  const BookingRoomBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CardTitle(
            title: "Phòng trọ cao cấp Q1", 
            imageUrl: "https://file4.batdongsan.com.vn/2025/12/23/20251223125240-cf4d_wm.jpg", 
            address: "123 Đường Nguyễn Huệ, Quận 1, TP.HCM", 
            price: 2800000
          ),
        ],
      ),
    );
  }
}