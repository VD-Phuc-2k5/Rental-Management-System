import '../../../core/constants.dart';
import 'package:flutter/material.dart';

class NoteInputField extends StatelessWidget {

  const NoteInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
  });
  final TextEditingController controller;
  final String label;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.blue950,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 1.0, color: AppColors.slate300),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: AppColors.slate400,
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16.0),
            ),
            style: const TextStyle(
              color: AppColors.blue950,
              fontFamily: "Inter",
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
