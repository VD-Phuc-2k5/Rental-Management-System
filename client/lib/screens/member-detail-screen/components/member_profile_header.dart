import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class MemberProfileHeader extends StatelessWidget {
  const MemberProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFE3D6),
              // boxShadow: [
              //   BoxShadow(
              //     color: AppColors.black.withOpacity(0.0),
              //     blurRadius: 10,
              //     offset: Offset(0, 4),
              //   ),
              // ],
              border: Border.all(color: AppColors.white, width: 4),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/Profile_Avatar.png',
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Nguyễn Minh Tuấn',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.blue950,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.blue700.withOpacity(0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.verified_user_outlined, size: 14, color: AppColors.blue700),
                SizedBox(width: 6),
                Text(
                  'Trưởng phòng',
                  style: TextStyle(
                    color: AppColors.blue700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Thành viên từ Tháng 05, 2023',
          style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}