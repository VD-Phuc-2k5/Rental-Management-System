import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

import 'section_header.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Mô tả", icon: Icons.info_outline),
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
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  "Mô tả về phòng: mới xây, gần trường đại học, an ninh tốt...",
              hintStyle: const TextStyle(
                fontFamily: "Noto Sans",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.slate400,
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
