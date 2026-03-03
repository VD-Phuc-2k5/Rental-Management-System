import 'package:app/core/constants.dart';
import 'package:app/screens/room-details-empty-screen/room_details_empty_screen.dart';
import 'package:app/screens/room-details-rented-screen/room_details_rented_screen.dart';
import 'package:app/screens/update-room-screen/update_room_screen.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String roomNumber;
  final bool isRented;
  final bool hasRedDot;
  final String roomType;
  final String? tenantName;
  final String? extraMembers;
  final String? expiryWarning;
  final String price;
  final String? avatarImagePath;

  const RoomCard({
    super.key,
    required this.roomNumber,
    required this.isRented,
    this.hasRedDot = false,
    required this.roomType,
    this.tenantName,
    this.extraMembers,
    this.expiryWarning,
    required this.price,
    this.avatarImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isRented) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RoomDetailsEmptyScreen(roomNumber: roomNumber),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RoomDetailsRentedScreen(roomNumber: roomNumber),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.slate100),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha(13),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        "P.$roomNumber",
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    if (hasRedDot)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.red500,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isRented ? AppColors.green100 : AppColors.gray100,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    isRented ? "Đang thuê" : "Còn trống",
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: isRented ? AppColors.green700 : AppColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.slate100),

                    image: (isRented && avatarImagePath != null)
                        ? DecorationImage(
                            image: AssetImage(avatarImagePath!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (isRented && avatarImagePath != null)
                      ? null
                      : (isRented
                            ? const Icon(
                                Icons.person,
                                color: AppColors.slate400,
                              )
                            : const Icon(
                                Icons.door_front_door_outlined,
                                color: AppColors.gray400,
                              )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomType,
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.slate900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isRented) ...[
                        Row(
                          children: [
                            Text(
                              tenantName ?? "",
                              style: const TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.slate900,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blue700,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: const Text(
                                "Trưởng phòng",
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          extraMembers ?? "",
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.slate500,
                          ),
                        ),
                        if (expiryWarning != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            expiryWarning!,
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppColors.orange600,
                            ),
                          ),
                        ],
                      ] else ...[
                        const Text(
                          "Chưa có khách thuê",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.slate100, height: 1),
            const SizedBox(height: 12),

            Text(
              price,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.blue700,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 30,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.blue700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdateRoomScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Cập nhật thông tin phòng",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.blue700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 30,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.blue700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  if (!isRented) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RoomDetailsEmptyScreen(roomNumber: roomNumber),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RoomDetailsRentedScreen(roomNumber: roomNumber),
                      ),
                    );
                  }
                },
                child: Text(
                  isRented ? "Xem chi tiết" : "Đăng bài",
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.blue700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
