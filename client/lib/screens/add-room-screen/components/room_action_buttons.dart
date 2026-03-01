import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class RoomActionButtons extends StatelessWidget {
  const RoomActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: AppColors.slate200))),
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy", style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.slate600)),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue700, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
              onPressed: () {},
              child: const Text("Lưu", style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.white)),
            ),
          ),
        ),
      ],
    );
  }
}