import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class RoomListFilter extends StatelessWidget {
  const RoomListFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Danh sách phòng",
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.slate900,
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                minimumSize: const Size(0, 30),
                side: const BorderSide(color: AppColors.blue700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16, color: AppColors.blue700),
              label: const Text(
                "Thêm phòng",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.blue700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Tìm tên phòng, khách thuê...",
            hintStyle: const TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppColors.gray400,
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.gray400),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                color: AppColors.slate100,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                color: AppColors.blue700,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
