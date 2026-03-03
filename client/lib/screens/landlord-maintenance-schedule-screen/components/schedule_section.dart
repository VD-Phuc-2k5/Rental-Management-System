import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleSection extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;

  const ScheduleSection({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onSelectDate,
    required this.onSelectTime,
  });

  Widget _buildSectionHeader() {
    return const Text(
      "Lịch hẹn",
      style: TextStyle(
        color: AppColors.blue950,
        fontFamily: "Inter",
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );
  }

  Widget _buildDateField() {
    final dateText = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        const Text(
          "Ngày hẹn sửa",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.slate700,
          ),
        ),
        GestureDetector(
          onTap: onSelectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.slate300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dateText.isEmpty ? 'dd/MM/yyyy' : dateText,
                    style: TextStyle(
                      fontSize: 16,
                      color: dateText.isEmpty
                          ? AppColors.slate400
                          : AppColors.slate900,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.slate400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    final timeText = selectedTime != null
        ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        const Text(
          "Giờ hẹn",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.slate700,
          ),
        ),
        GestureDetector(
          onTap: onSelectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.slate300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    timeText.isEmpty ? '--:--' : timeText,
                    style: TextStyle(
                      fontSize: 16,
                      color: timeText.isEmpty
                          ? AppColors.slate400
                          : AppColors.slate900,
                    ),
                  ),
                ),
                const Icon(
                  Icons.access_time_outlined,
                  color: AppColors.slate400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1.0, color: AppColors.slate200),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          _buildSectionHeader(),
          Row(
            children: [
              Expanded(child: _buildDateField()),
              const SizedBox(width: 16),
              Expanded(child: _buildTimeField()),
            ],
          ),
        ],
      ),
    );
  }
}
