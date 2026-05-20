import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class TenantBottomBar extends StatelessWidget {
  final VoidCallback onNext;

  const TenantBottomBar({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFDCE0E5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onNext,
            style: const ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(AppColors.blue700),
              foregroundColor:
                  WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
              ),
            ),
            child: Text(
              'Tiếp theo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}