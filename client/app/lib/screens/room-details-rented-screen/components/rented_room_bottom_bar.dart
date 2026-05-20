import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class RentedRoomBottomBar extends StatelessWidget {
  const RentedRoomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.slate200, width: 1.0)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.white,
            side: const BorderSide(color: AppColors.blue700, width: 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "Hủy hợp đồng",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.blue700,
            ),
          ),
        ),
      ),
    );
  }
}
