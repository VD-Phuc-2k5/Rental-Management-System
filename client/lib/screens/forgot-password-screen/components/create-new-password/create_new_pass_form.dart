import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class NewPassInputForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const NewPassInputForm({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<NewPassInputForm> createState() => _NewPassInputFormState();
}

class _NewPassInputFormState extends State<NewPassInputForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Mật khẩu mới',
            style: TextStyle(
              color: AppColors.slate700,
              fontSize: 16,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.passwordController,
            obscureText: _obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(fontSize: 16, fontFamily: 'Nunito'),
            decoration: InputDecoration(
              hintText: '********',
              hintStyle: const TextStyle(
                color: AppColors.slate400,
                fontSize: 16,
                fontFamily: 'Nunito',
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.slate400,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.slate400,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: const BorderSide(color: AppColors.slate200, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: const BorderSide(
                  color: AppColors.blue700,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Xác nhận mật khẩu',
            style: TextStyle(
              color: AppColors.slate700,
              fontSize: 16,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(fontSize: 16, fontFamily: 'Nunito'),
            decoration: InputDecoration(
              hintText: '********',
              hintStyle: const TextStyle(
                color: AppColors.slate400,
                fontSize: 16,
                fontFamily: 'Nunito',
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.slate400,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.slate400,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: const BorderSide(color: AppColors.slate200, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: const BorderSide(
                  color: AppColors.blue700,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}