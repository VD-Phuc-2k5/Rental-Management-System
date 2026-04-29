import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class WarningMessage extends StatelessWidget {
  const WarningMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Text(
        'Bạn đang chuyển quyền quản lý phòng và các nghĩa vụ hợp đồng cho thành viên khác. Hành động này không thể hoàn tác.',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.slate700,
          height: 1.5,
        ),
      ),
    );
  }
}
