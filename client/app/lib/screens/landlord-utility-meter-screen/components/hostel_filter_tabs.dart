import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class HostelFilterTabs extends StatelessWidget {
  final List<String> hostels;
  final String? selectedHostel;
  final ValueChanged<String?>? onHostelSelected;

  const HostelFilterTabs({
    super.key,
    required this.hostels,
    this.selectedHostel,
    this.onHostelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        spacing: 8.0,
        children: [
          _buildTab("Tất cả", null),
          ...hostels.map((hostel) => _buildTab(hostel, hostel)),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String? value) {
    final isSelected = selectedHostel == value;

    return GestureDetector(
      onTap: () => onHostelSelected?.call(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue950 : AppColors.slate100,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.slate600,
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
