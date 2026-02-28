import 'package:flutter/material.dart';

class RegisterRentAppointmentSection extends StatelessWidget {
  const RegisterRentAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),side: BorderSide(
        color: Color(0xFFDCE0E5),
      width: 1,
      )),
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
            _InfoRow(
              icon: Icons.calendar_month_outlined,
              title: 'Thời gian',
              value: '09:30 - Thứ Ba, 24/10/2023',
            ),
            SizedBox(height: 12),
            _InfoRow(
              icon: Icons.person_outline,
              title: 'Người dẫn xem',
              value: 'Nguyễn Văn Chủ',
            ),
            SizedBox(height: 12),
            _InfoRow(
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xFF647487), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF647487),fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF111417))),
            ],
          ),
        ),
      ],
    );
  }
}