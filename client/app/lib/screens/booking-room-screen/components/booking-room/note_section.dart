import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class NoteSection extends StatelessWidget {
  final TextEditingController controller;

  const NoteSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Ghi chú',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Nunito',
                ),
              ),
              TextSpan(
                text: ' (tùy chọn)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(fontSize: 14, fontFamily: 'Nunito'),
          decoration: InputDecoration(
            hintText: 'Thêm ghi chú cho chủ trọ...',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'Nunito',
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(8),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.slate200, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.blue700, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
