import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.blue700.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.blue700, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppColors.slate500,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.slate900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: const Color(0x1A000000)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.mail_outline, "EMAIL", "vana@email.com"),
          const Padding(
            padding: EdgeInsets.only(left: 56, top: 16, bottom: 16),
            child: Divider(color: AppColors.slate100, height: 1),
          ),
          _buildInfoRow(Icons.phone_iphone, "SỐ ĐIỆN THOẠI", "0912 345 678"),
          const Padding(
            padding: EdgeInsets.only(left: 56, top: 16, bottom: 16),
            child: Divider(color: AppColors.slate100, height: 1),
          ),
          _buildInfoRow(Icons.cake_outlined, "NGÀY SINH", "15/05/1990"),
        ],
      ),
    );
  }
}
