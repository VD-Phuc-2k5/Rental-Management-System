import 'package:flutter/material.dart';
import 'cccd_upload.dart';

class TenantInfoForm extends StatelessWidget {
  final TextEditingController nameCtl;
  final TextEditingController dobCtl;
  final TextEditingController cccdCtl;
  final TextEditingController addressCtl;
  final TextEditingController phoneCtl;
  final TextEditingController emailCtl;
  final VoidCallback onPickDate;

  const TenantInfoForm({
    super.key,
    required this.nameCtl,
    required this.dobCtl,
    required this.cccdCtl,
    required this.addressCtl,
    required this.phoneCtl,
    required this.emailCtl,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LabeledField(
          label: 'Họ và tên',
          requiredMark: true,
          controller: nameCtl,
          hint: 'Nhập họ và tên',
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Ngày sinh',
          controller: dobCtl,
          hint: 'dd/mm/yyyy',
          readOnly: true,
          suffixIcon: Icons.calendar_month_outlined,
          onTap: onPickDate,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Số CCCD',
          requiredMark: true,
          controller: cccdCtl,
          hint: 'Nhập số CCCD',
        ),
        const SizedBox(height: 12),

        const TenantCccdUploadSection(),
        const SizedBox(height: 12),

        _LabeledField(
          label: 'Địa chỉ thường trú',
          controller: addressCtl,
          hint: 'Nhập địa chỉ',
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Số điện thoại',
          requiredMark: true,
          controller: phoneCtl,
          hint: 'Nhập số điện thoại',
          keyboardType: TextInputType.phone,
          suffixIcon: Icons.call_outlined,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Email',
          controller: emailCtl,
          hint: 'Nhập địa chỉ email',
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icons.mail_outline,
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final bool requiredMark;
  final TextEditingController controller;
  final String hint;
  final bool readOnly;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int maxLines;

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hint,
    this.requiredMark = false,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Color(0xFF111417),
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(text: label),
              if (requiredMark)
                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF647487),
              fontSize: 16,
            ),
            suffixIcon: suffixIcon == null ? null : Icon(
              suffixIcon,
              color: const Color(0xFF647487),),
            filled: true,
            fillColor:  Color(0xFFFFFFFF),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFDCE0E5)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}