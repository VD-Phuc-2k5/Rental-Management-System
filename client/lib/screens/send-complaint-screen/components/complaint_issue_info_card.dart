import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class ComplaintIssueInfoCard extends StatelessWidget {
  const ComplaintIssueInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THÔNG TIN SỰ CỐ',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hỏng vòi nước',
                    style: TextStyle(
                      color: AppColors.blue700,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Phòng 302 - Nhà A1',
                    style: TextStyle(
                      color: AppColors.gray600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              // decoration: BoxDecoration(
              //   color: const Color(0xFFF1F5F9),
              //   borderRadius: BorderRadius.circular(999),
              // ),
              child: const Text(
                'READ-ONLY',
                style: TextStyle(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}