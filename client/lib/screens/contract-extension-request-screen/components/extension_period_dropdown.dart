import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ExtensionPeriodDropdown extends StatelessWidget {
  final int selectedMonths;
  final ValueChanged<int?> onChanged;

  const ExtensionPeriodDropdown({
    super.key,
    required this.selectedMonths,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Text(
          "Thời gian gia hạn mong muốn",
          style: TextStyle(
            color: AppColors.blue950,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 1.0, color: AppColors.slate300),
          ),
          child: DropdownButtonFormField<int>(
            initialValue: selectedMonths,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.slate500),
            items: [3, 6, 9, 12, 24]
                .map(
                  (months) => DropdownMenuItem<int>(
                    value: months,
                    child: Text(
                      "$months tháng",
                      style: TextStyle(
                        color: AppColors.blue950,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
