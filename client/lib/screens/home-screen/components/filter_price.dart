import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class FilterPrice extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const FilterPrice({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createFilterButton("Tất cả", 0),
          _createFilterButton("Dưới 2tr", 1),
          _createFilterButton("2 - 4tr", 2),
          _createFilterButton("Trên 4tr", 3),
        ],
      ),
    );
  }

  Widget _createFilterButton(String label, int index) {
    bool isSelected = currentIndex == index;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap != null ? () => onTap!(index) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue700 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}