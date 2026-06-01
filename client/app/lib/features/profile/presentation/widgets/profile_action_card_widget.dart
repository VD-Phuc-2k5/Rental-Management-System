import 'package:core/constants.dart';
import 'package:flutter/material.dart';

class ProfileActionCardWidget extends StatelessWidget {
  const ProfileActionCardWidget({
    super.key,
    required this.onChangePassword,
    required this.onSupport,
    required this.onLogout,
  });

  final VoidCallback onChangePassword;
  final VoidCallback onSupport;
  final VoidCallback onLogout;

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.slate700,
    bool showArrow = true,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: color == AppColors.red500
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 16,
                      color: color,
                    ),
                  ),
                ),
                if (showArrow)
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.slate400,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(color: AppColors.slate100, height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: const Color(0x1A000000)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          _buildActionRow(
            icon: Icons.lock_outline,
            title: 'Đổi mật khẩu',
            onTap: onChangePassword,
          ),
          _buildActionRow(
            icon: Icons.help_outline,
            title: 'Trung tâm hỗ trợ',
            onTap: onSupport,
          ),
          _buildActionRow(
            icon: Icons.logout,
            title: 'Đăng xuất',
            onTap: onLogout,
            color: AppColors.red500,
            showArrow: false,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
