import "package:app/core/constants.dart";
import "package:flutter/material.dart";

enum Priority { low, medium, high }

class PrioritySelector extends StatelessWidget {
  final Priority selectedPriority;
  final Function(Priority) onPrioritySelected;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        const Text(
          "Mức độ ưu tiên",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Row(
          spacing: 10.0,
          children: [
            _buildPriorityButton(label: "Thấp", priority: Priority.low),
            _buildPriorityButton(
              label: "Trung bình",
              priority: Priority.medium,
            ),
            _buildPriorityButton(label: "Cao", priority: Priority.high),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityButton({
    required String label,
    required Priority priority,
  }) {
    final isSelected = selectedPriority == priority;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onPrioritySelected(priority),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.blue700 : AppColors.slate100,
          elevation: isSelected ? 2 : 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.blue700,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
