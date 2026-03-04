import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class CancelFormSection extends StatefulWidget {
  const CancelFormSection({super.key});

  @override
  State<CancelFormSection> createState() => _CancelFormSectionState();
}

class _CancelFormSectionState extends State<CancelFormSection> {
  String? _selectedReason;

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.slate900,
          ),
          children: isRequired
              ? const [
                  TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.slate100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Ngày dự kiến trả phòng", isRequired: true),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: "mm/dd/yyyy",
              hintStyle: const TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.slate900,
              ),
              suffixIcon: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.slate500,
                size: 20,
              ),
              filled: true,
              fillColor: AppColors.slate50,
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
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel("Lý do trả phòng", isRequired: true),
          DropdownButtonFormField<String>(
            value: _selectedReason,
            hint: const Text(
              "Chọn lý do",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                color: AppColors.slate900,
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.slate500,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.slate50,
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
            ),
            items: ["Chuyển chỗ làm", "Về quê", "Lý do khác"]
                .map(
                  (reason) =>
                      DropdownMenuItem(value: reason, child: Text(reason)),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedReason = value;
              });
            },
          ),
          const SizedBox(height: 16),

          _buildLabel("Chi tiết lý do"),
          TextFormField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Nhập thêm chi tiết (nếu có)...",
              hintStyle: const TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.slate500,
              ),
              filled: true,
              fillColor: AppColors.slate50,
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
            ),
          ),
        ],
      ),
    );
  }
}
