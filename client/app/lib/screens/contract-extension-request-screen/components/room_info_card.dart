import '../../../core/constants.dart';
import 'package:flutter/material.dart';

class RoomInfoCard extends StatelessWidget {

  const RoomInfoCard({
    super.key,
    required this.roomName,
    required this.hostelName,
    required this.contractExpiryDate,
  });
  final String roomName;
  final String hostelName;
  final String contractExpiryDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 1.0, color: AppColors.slate200),
      ),
      child: Column(
        spacing: 12.0,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: const Border(
                bottom: BorderSide(width: 1.0, color: AppColors.slate200),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              spacing: 12.0,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: AppColors.blue50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.apartment, color: AppColors.blue700),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      style: const TextStyle(
                        color: AppColors.blue950,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      hostelName,
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  spacing: 8.0,
                  children: [
                    Icon(Icons.event_busy, color: AppColors.slate500, size: 18),
                    Text(
                      "Hết hạn hợp đồng:",
                      style: TextStyle(
                        color: AppColors.slate500,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  contractExpiryDate,
                  style: const TextStyle(
                    color: AppColors.red500,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
