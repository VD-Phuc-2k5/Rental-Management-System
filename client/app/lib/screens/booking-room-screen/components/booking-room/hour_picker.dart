import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class HourPicker extends StatelessWidget {
  final List<String> hours;
  final String? selectedHour;
  final ValueChanged<String> onHourSelected;

  const HourPicker({
    super.key,
    required this.hours,
    this.selectedHour,
    required this.onHourSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Chọn giờ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "Nunito",
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: hours.map((hour) {
            final isSelected = hour == selectedHour;
            return GestureDetector(
              onTap: () => onHourSelected(hour),
              child: Container(
                width: 80,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.blue700 : AppColors.slate200,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  hour,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.slate500,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 14
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
