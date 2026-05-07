import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

Color _getStatusIconColor(String status) {
  switch (status) {
    case 'Chờ xử lý':
      return AppColors.orange500;
    case 'Đã xác nhận':
      return AppColors.green600;
    case 'Đã huỷ':
      return AppColors.red600;
    default:
      return AppColors.slate500;
  }
}

Color _getStatusIconBackground(String status) {
  switch (status) {
    case 'Chờ xử lý':
      return AppColors.orange50;
    case 'Đã xác nhận':
      return AppColors.green100;
    case 'Đã huỷ':
      return AppColors.red100;
    default:
      return AppColors.slate100;
  }
}

Color _getStatusTextColor(String status) {
  switch (status) {
    case 'Chờ xử lý':
      return AppColors.red700;
    case 'Đã xác nhận':
      return AppColors.green600;
    case 'Đã huỷ':
      return AppColors.red600;
    default:
      return AppColors.slate500;
  }
}

Color _getStatusTextBackground(String status) {
  switch (status) {
    case 'Chờ xử lý':
      return AppColors.orange100;
    case 'Đã xác nhận':
      return AppColors.green100;
    case 'Đã huỷ':
      return AppColors.red100;
    default:
      return AppColors.slate100;
  }
}

class RequestDetailCard extends StatelessWidget {
  final String date;
  final String? note;
  final String status;

  const RequestDetailCard({
    super.key,
    required this.date,
    this.note,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(18),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: AppColors.slate200, width: 1),
      ),
      child: Column(
        children: [
          _buildInfo(
            "Ngày mong muốn",
            date,
            Icons.calendar_month_outlined,
            AppColors.blue500,
            AppColors.blue50,
          ),
          const SizedBox(height: 16.0),
          _buildInfo(
            "Ghi chú", 
            note, Icons.subject_outlined, 
            AppColors.slate500, 
            AppColors.slate50,
            isNote: true,
          ),
          const SizedBox(height: 16.0),
          _buildInfo(
            "Trạng thái",
            status,
            Icons.pending_outlined,
            _getStatusIconColor(status),
            _getStatusIconBackground(status),
            isStatus: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(
    String title,
    String? value,
    IconData icon,
    Color iconColor,
    Color iconBackgroundColor, {
    bool isNote = false,
    bool isStatus = false,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.0,
                color: AppColors.slate500,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4.0),
            !isStatus
                ? Text(
                    isNote ? '"$value"' : value ?? "Không có ghi chú",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: isNote ? AppColors.slate500 : AppColors.slate900,
                      fontFamily: "Inter",
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusTextBackground(value ?? ""),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      value ?? "Không có trạng thái",
                      style: TextStyle(
                        color: _getStatusTextColor(value ?? ""),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
          ],
          ),
        ),
      ],
    );
  }
}
