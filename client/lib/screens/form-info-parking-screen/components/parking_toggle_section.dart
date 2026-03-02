import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class ParkingToggleSection extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ParkingToggleSection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Khách có gửi xe không?',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.slate800),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Bật để thêm thông tin gửi xe của\nkhách',
                    style: TextStyle(color: AppColors.slate500,fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.blue700, 
              activeColor: Colors.white,                
              inactiveTrackColor: AppColors.gray200,
              inactiveThumbColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}