import 'package:flutter/material.dart';
import 'package:domain/room.dart'; // Thêm dòng này để dùng RoomEntity

import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';

import 'components/empty_tenant_state.dart';
import 'components/room_details_bottom_bar.dart';
import 'components/room_info_card.dart';

class RoomDetailsEmptyScreen extends StatelessWidget {
  const RoomDetailsEmptyScreen({
    super.key,
    required this.room, // Thay roomNumber thành biến room động
    required this.propertyName, // Thêm tên khu trọ
  });

  final RoomEntity room;
  final String propertyName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: CommonAppBar(title: "Chi tiết phòng ${room.title}"), // Lấy tên phòng từ dữ liệu thật

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // TRUYỀN DỮ LIỆU ĐỘNG VÀO THẺ THÔNG TIN PHÒNG
                  RoomInfoCard(
                    room: room,
                    propertyName: propertyName,
                  ),
                  const EmptyTenantState(),
                ],
              ),
            ),
          ),
          const RoomDetailsBottomBar(),
        ],
      ),
    );
  }
}