import 'package:flutter/material.dart';

import 'info_row.dart';

class AppointmentInfoCard extends StatelessWidget {
  const AppointmentInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Thông tin lịch hẹn',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            InfoRow(
              icon: Icons.calendar_month_outlined,
              title: 'Thời gian',
              value: '09:30 - Thứ Ba, 24/10/2023',
            ),
            SizedBox(height: 12),
            InfoRow(
              icon: Icons.person_outline,
              title: 'Người dẫn xem',
              value: 'Nguyễn Văn Chủ',
            ),
            SizedBox(height: 12),
            InfoRow(
              icon: Icons.notes_outlined,
              title: 'Ghi chú',
              value: 'Gọi trước 30p khi đến',
            ),
          ],
        ),
      ),
    );
  }
}