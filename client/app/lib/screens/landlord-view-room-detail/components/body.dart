import 'request_detail_card.dart';
import 'response_card.dart';
import 'room_summary_card.dart';
import 'package:flutter/material.dart';

class LandlordViewRoomDetailBody extends StatelessWidget {
  const LandlordViewRoomDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        children: [
          RoomSummaryCard(roomName: "adaaa", address: "123 Main Street", imageUrl: "https://example.com/image.jpg"),
          RequestDetailCard(date: "Thứ 3, 25/02/2026 10:00", note: "Em muốn xem phòng vào buổi sáng", status: "Chờ xử lý"),
          ResponseCard(
            scheduledDate: "Thứ 3, 25/02/2026 10:00"
          ),
        ],
      ),
    );
  }
}