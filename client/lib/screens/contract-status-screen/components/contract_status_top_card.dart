import 'package:flutter/material.dart';

class ContractStatusTopCard extends StatelessWidget {
  const ContractStatusTopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
        child: Column(
          children: const [
            _HourglassIcon(),
            SizedBox(height: 14),
            Text(
              'Đang chờ khách thuê ký',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Hợp đồng mới đã được gửi đến Nguyễn Văn\nA lúc 10:30, 01/03/2026.',
              style: TextStyle(color: Color(0xFF647487), height: 1.25),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HourglassIcon extends StatelessWidget {
  const _HourglassIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFFF3E8),
      ),
      child: const Icon(
        Icons.hourglass_empty_rounded,
        size: 34,
        color: Color(0xFFF97316),
      ),
    );
  }
}