import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class RoomOwnerSection extends StatelessWidget {
  final String ownerName;
  final String ownerAvatar;
  final String ownerRole;
  final String ownerBadge;
  final bool isOnline;
  final VoidCallback? onCallPressed;

  const RoomOwnerSection({
    super.key,
    required this.ownerName,
    required this.ownerAvatar,
    this.ownerRole = 'Chủ trọ',
    this.ownerBadge = 'Phản hồi nhanh',
    this.isOnline = true,
    this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.slate200, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    ownerAvatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.slate200,
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: AppColors.slate400,
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ownerName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$ownerRole • $ownerBadge',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCallPressed,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.slate300, width: 1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.phone, size: 24, color: AppColors.blue700),
            ),
          ),
        ],
      );
  }
}
