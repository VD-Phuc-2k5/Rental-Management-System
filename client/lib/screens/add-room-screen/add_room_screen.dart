import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'components/add_room_body.dart';

class AddRoomScreen extends StatelessWidget {
  const AddRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate900),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          "Thêm phòng mới",
          style: TextStyle(
            color: AppColors.slate900,
            fontFamily: "Public Sans",
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.45,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate200, height: 1.0),
        ),
      ),
      body: const AddRoomBody(),
    );
  }
}