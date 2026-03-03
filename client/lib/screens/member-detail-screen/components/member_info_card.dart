import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class MemberInfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRowData> rows;

  const MemberInfoCard({
    super.key,
    required this.title,
    required this.rows,
  });

  const MemberInfoCard.contact({super.key})
      : title = 'THÔNG TIN LIÊN HỆ',
        rows = const [
          _InfoRowData(
            icon: Icons.call,
            label: 'Số điện thoại',
            value: '0901 234 567',
          ),
          _InfoRowData(
            icon: Icons.mail_outline,
            label: 'Email',
            value: 'tuan.nguyen@nhatroplus.com',
          ),
        ];

  const MemberInfoCard.identity({super.key})
      : title = 'THÔNG TIN ĐỊNH DANH',
        rows = const [
          _InfoRowData(
            icon: Icons.badge_outlined,
            label: 'Số CCCD / CMND',
            value: '012345678901',
          ),
          _InfoRowData(
            icon: Icons.cake_outlined,
            label: 'Ngày sinh',
            value: '15/05/1995',
          ),
          _InfoRowData(
            icon: Icons.location_on_outlined,
            label: 'Địa chỉ thường trú',
            value: '123 Đường Lê Lợi, Phường Bến\nThành, Quận 1, TP. Hồ Chí Minh',
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.slate400,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            ...rows.map((r) => _InfoRow(r)).toList(),
          ],
        ),
      ),
    );
  }
}

class _InfoRowData {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRowData({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _InfoRow extends StatelessWidget {
  final _InfoRowData data;
  const _InfoRow(this.data);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue700.withOpacity(0.1),
            ),
            child: Icon(data.icon, color: AppColors.blue700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: const TextStyle(
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.value,
                  style: const TextStyle(
                    color: AppColors.blue950,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.2,
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