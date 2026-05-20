import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class FinishContractBottomBar extends StatelessWidget {
  const FinishContractBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.slate100, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Xử lý logic kết thúc hợp đồng
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Xác nhận hoàn cọc & kết thúc",
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: AppColors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
