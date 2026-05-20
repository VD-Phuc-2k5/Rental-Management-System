import "package:app/core/constants.dart";
import "package:flutter/material.dart";

class LabeledTextField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String hintText;
  final int maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const LabeledTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.hintText,
    this.maxLines = 1,
    this.maxLength,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Row(
          spacing: 3.0,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            if (isRequired)
              const Text("*", style: TextStyle(color: AppColors.red500)),
          ],
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLength: maxLength,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.slate100,
            hintText: hintText,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: AppColors.slate200),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: AppColors.blue700),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: AppColors.red500),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: AppColors.red500),
            ),
          ),
        ),
      ],
    );
  }
}
