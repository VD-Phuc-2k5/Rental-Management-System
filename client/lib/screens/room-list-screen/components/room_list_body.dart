import 'package:flutter/material.dart';

import 'hostel_info_header.dart';
import 'room_card.dart';
import 'room_list_filter.dart';

class RoomListBody extends StatelessWidget {
  const RoomListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        HostelInfoHeader(),
        SizedBox(height: 16),
        RoomListFilter(),
        SizedBox(height: 16),
        RoomCard(
          roomNumber: "101",
          isRented: true,
          avatarImagePath: "assets/images/room-list-screen/avt_img1.jpg",
          roomType: "Phòng đơn lầu 1",
          tenantName: "Nguyễn Văn A",
          extraMembers: "+ 2 thành viên",
          price: "2.800.000đ",
        ),
        RoomCard(
          roomNumber: "102",
          isRented: false,
          roomType: "Phòng đơn lầu 1",
          price: "3.000.000đ",
        ),
        RoomCard(
          roomNumber: "103",
          isRented: false,
          roomType: "Phòng đơn lầu 2",
          price: "3.000.000đ",
        ),
        RoomCard(
          roomNumber: "201",
          isRented: true,
          hasRedDot: true,
          avatarImagePath: "assets/images/room-list-screen/avt_img2.jpg",
          roomType: "Phòng VIP lầu 2",
          tenantName: "Trần Thị B",
          expiryWarning: "Sắp hết hạn: 15/10",
          price: "3.500.000đ",
        ),
      ],
    );
  }
}
