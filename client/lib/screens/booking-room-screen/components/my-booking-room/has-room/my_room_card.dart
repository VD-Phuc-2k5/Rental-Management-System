import 'package:app/core/constants.dart';
import 'package:app/screens/register-rent-screen/register_rent_screen.dart';
import 'package:flutter/material.dart';

enum BookingStatus { pending, confirmed, cancelled }

class MyRoom {
  final String imageUrl;
  final String roomName;
  final String address;
  final String bookingTime;
  final BookingStatus status;

  MyRoom({
    required this.imageUrl,
    required this.roomName,
    required this.address,
    required this.bookingTime,
    required this.status,
  });
}

class MyRoomCard extends StatelessWidget {
  const MyRoomCard({
    super.key,
    required this.rooms,
  });

  final List<MyRoom> rooms;

  String _statusLabel(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Chờ xác nhận';
      case BookingStatus.confirmed:
        return 'Đã xác nhận';
      case BookingStatus.cancelled:
        return 'Đã hủy';
    }
  }

  Color _statusBackgroundColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppColors.slate100;
      case BookingStatus.confirmed:
        return AppColors.emerald100;
      case BookingStatus.cancelled:
        return AppColors.red100;
    }
  }

  Color _statusTextColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppColors.slate700;
      case BookingStatus.confirmed:
        return AppColors.emerald700;
      case BookingStatus.cancelled:
        return AppColors.red700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegisterRentScreen()),
        );
      },
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rooms.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final room = rooms[index];

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    room.imageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room.roomName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBackgroundColor(room.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _statusLabel(room.status),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _statusTextColor(room.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        room.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.slate500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 16,
                            color: AppColors.blue700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            room.bookingTime,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}