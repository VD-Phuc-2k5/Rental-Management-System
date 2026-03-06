import 'package:app/core/constants.dart';
import 'package:app/screens/member-detail-screen/member_detail_screen.dart';
import 'package:flutter/material.dart';

class TenantListSection extends StatelessWidget {
  const TenantListSection({super.key});

  Widget _buildTenantRow(
    BuildContext context,
    String name,
    String phone,
    String role,
    bool isLeader,
  ) {
    String initialLetter = name.trim().split(' ').last[0].toUpperCase();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MemberDetailScreen()),
      ),
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.blue100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initialLetter,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.blue700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.phone, size: 14, color: AppColors.slate500),
                  const SizedBox(width: 4),
                  Text(
                    phone,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isLeader ? AppColors.blue700 : AppColors.slate100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isLeader ? AppColors.white : AppColors.slate600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Icon(Icons.chevron_right, color: AppColors.slate300, size: 24),
        ),
      ],
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTenantRow(context, "Nguyễn Văn A", "0912 345 678", "Trưởng phòng", true),
          const SizedBox(height: 16),
          _buildTenantRow(context, "Nguyễn Văn B", "0912 345 679", "Thành viên", false),
          const SizedBox(height: 16),
          const Divider(color: AppColors.slate100, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Ngày vào ở",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.slate500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "15/05/2023",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.slate900,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Giá thuê",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.slate500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "4.500.000 đ",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.blue700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
            ],
          ),
        ],
      ),
    );
  }
}
