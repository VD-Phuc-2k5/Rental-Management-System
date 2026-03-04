import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class CancelContractBottomBar extends StatelessWidget {
  const CancelContractBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.slate200, width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            // Xử lý logic gửi yêu cầu
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Xác nhận gửi yêu cầu",
            style: TextStyle(
              color: AppColors.white,
              fontFamily: "Inter",
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
