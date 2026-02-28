import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.slate200, width: 1.0)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue700,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              // TODO: Lưu thông tin và chuyển qua Screen 13.2
              onPressed: null,
              child: const Text(
                "Thêm nhà trọ",
                style: TextStyle(
                  fontFamily: "Public Sans",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: AppColors.slate200, width: 2),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Hủy",
                style: TextStyle(
                  fontFamily: "Public Sans",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.slate600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}