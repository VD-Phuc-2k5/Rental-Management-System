import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class RoomListSection extends StatelessWidget {
  const RoomListSection({super.key});

  Widget _buildRoomItem(String roomNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: AppColors.black.withAlpha(13), blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), border: Border.all(color: const Color(0xFFDBEAFE)), shape: BoxShape.circle),
            child: Center(child: Text("P.$roomNumber", style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.blue700))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phòng $roomNumber", style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.slate900)),
                const SizedBox(height: 2),
                const Text("Tầng 1 • 25m² • 3.5tr", style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w400, fontSize: 12, color: AppColors.slate500)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.slate400), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.slate400), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("DANH SÁCH PHÒNG", style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.slate900, letterSpacing: 0.35)),
        const SizedBox(height: 12),
        _buildRoomItem("101"),
        _buildRoomItem("102"),
      ],
    );
  }
}