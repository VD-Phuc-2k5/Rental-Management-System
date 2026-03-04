import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

import 'section_header.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Vị trí", icon: Icons.info_outline),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextField(
            controller: TextEditingController(
              text: "Khu A, 123 Nguyễn Trãi, Quận 5, thành phố Hồ Chí Minh",
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              fontFamily: "Public Sans",
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppColors.slate700,
            ),
            decoration: InputDecoration(
              prefixIcon: const Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: AppColors.slate400, size: 20),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.blue700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
