import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ConfirmationSection extends StatelessWidget {
  final bool isConfirmed;
  final ValueChanged<bool> onChanged;
  final VoidCallback onSubmit;
  final bool isValid;

  const ConfirmationSection({
    super.key,
    required this.isConfirmed,
    required this.onChanged,
    required this.onSubmit,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isConfirmed,
              onChanged: (value) => onChanged(value ?? false),
              activeColor: AppColors.blue700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(!isConfirmed),
                child: const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Tôi hiểu và đồng ý chuyển toàn bộ quyền hạn trưởng phòng.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.slate700,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isValid ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue700,
              disabledBackgroundColor: AppColors.slate300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Xác nhận chuyển quyền',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
