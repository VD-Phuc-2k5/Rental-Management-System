import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class EquipmentSectionUi extends StatelessWidget {
  const EquipmentSectionUi({super.key});

  @override
  Widget build(BuildContext context) {
    const selected = {'Máy lạnh', 'Nóng lạnh'};
    const items = ['Máy lạnh', 'Nóng lạnh', 'Tủ lạnh', 'Giường', 'Bàn ghế', 'Tủ quần áo'];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((e) {
        final isOn = selected.contains(e);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isOn ? AppColors.blue700 : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: isOn ? AppColors.blue700 : const Color(0xFFE2E8F0)),
          ),
          child: Text(
            e,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isOn ? Colors.white : const Color(0xFF647487),
            ),
          ),
        );
      }).toList(),
    );
  }
}