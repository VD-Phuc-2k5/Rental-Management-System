import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class PasswordInputSection extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInputSection({super.key, required this.controller});

  @override
  State<PasswordInputSection> createState() => _PasswordInputSectionState();
}

class _PasswordInputSectionState extends State<PasswordInputSection> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Xác nhận danh tính',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColors.slate900,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: AppColors.slate200),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              const Text(
                'Mật khẩu ứng dụng',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.blue900,
                ),
              ),

              TextField(
                controller: widget.controller,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Nhập mật khẩu để xác thực',
                  hintStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.slate400,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.slate400,
                      size: 20,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: AppColors.slate200,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: AppColors.slate200,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: AppColors.blue700,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: AppColors.red600,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
