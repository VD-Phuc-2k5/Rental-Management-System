import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class UtilitiesSectionUi extends StatelessWidget {
  final TextEditingController elecPriceCtl;
  final TextEditingController waterPriceCtl;
  final TextEditingController parkingFeeCtl;

  const UtilitiesSectionUi({
    super.key,
    required this.elecPriceCtl,
    required this.waterPriceCtl,
    required this.parkingFeeCtl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _BoxInput(
                    label: 'Giá điện (VND/kWh)',
                    controller: elecPriceCtl,
                    hint: '3.500',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BoxInput(
                    label: 'Giá nước (VND/m³)',
                    controller: waterPriceCtl,
                    hint: '10.000',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _BoxInput(
              label: 'Phí gửi xe (VND)',
              controller: parkingFeeCtl,
              hint: '150.000',
            ),
          ],
        ),
      ),
    );
  }
}

class _BoxInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;

  const _BoxInput({
    required this.label,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F7),
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.gray900,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFF9CA3AF),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}