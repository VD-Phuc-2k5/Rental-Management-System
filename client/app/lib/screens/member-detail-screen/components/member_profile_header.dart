import 'package:flutter/material.dart';
import '../../../core/constants.dart';
class MemberProfileHeader extends StatelessWidget {
  const MemberProfileHeader({
    super.key,
    this.name,
    this.role,
    this.avatar,
    this.joinMonth,
    this.joinYear,
  });
  final String? name;
  final String? role;
  final ImageProvider? avatar;
  final int? joinMonth;
  final int? joinYear;

  @override
  Widget build(BuildContext context) {
    final displayName = name ?? '';
    final displayRole = role ?? '';
    final m = joinMonth;
    final y = joinYear;
    final joinText = (m != null && y != null)
    ? 'Thành viên từ Tháng ${m.toString().padLeft(2, '0')}, $y'
    : '';
    return Column(
      children: [
        Center(
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFE3D6),
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
              child: Image(
                image: avatar ?? const AssetImage('assets/images/profile_avatar_member.png'),
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
         Text(
           displayName,
          style: const TextStyle(
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
              color: AppColors.blue700.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.blue700),
                const SizedBox(width: 6),
                Text(
                  displayRole,
                  style: const TextStyle(
                    color: AppColors.blue700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          joinText,
          style: const TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}