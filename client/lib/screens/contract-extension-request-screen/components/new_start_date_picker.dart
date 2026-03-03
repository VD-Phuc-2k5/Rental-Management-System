import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewStartDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final DateTime? contractExpiryDate;

  const NewStartDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.contractExpiryDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Text(
          "Ngày bắt đầu hợp đồng mới",
          style: TextStyle(
            color: AppColors.blue950,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(width: 1.0, color: AppColors.slate300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(selectedDate),
                  style: TextStyle(
                    color: AppColors.blue950,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                Icon(Icons.calendar_today, color: AppColors.slate500, size: 20),
              ],
            ),
          ),
        ),
        if (contractExpiryDate != null &&
            selectedDate.isBefore(contractExpiryDate!))
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "*Mặc định là ngày kế tiếp sau khi hết hạn hợp đồng cũ.",
              style: TextStyle(
                color: AppColors.slate500,
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
