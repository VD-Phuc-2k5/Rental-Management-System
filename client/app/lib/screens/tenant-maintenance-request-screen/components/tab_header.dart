import "package:app/core/constants.dart";
import "package:flutter/material.dart";

class TabHeader extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> tabs;

  const TabHeader({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: AppColors.slate200),
        ),
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(child: _buildTab(index)),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    final isSelected = selectedIndex == index;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2.0,
            color: isSelected ? AppColors.blue700 : AppColors.slate100,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: () => onTabSelected(index),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.only(bottom: 10.0),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          tabs[index],
          style: TextStyle(
            color: isSelected ? AppColors.blue700 : AppColors.slate500,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
