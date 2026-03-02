import 'package:flutter/material.dart';

class ContractStatusActions extends StatelessWidget {
  const ContractStatusActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 52,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {}, // UI-only
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF195AA4)),
            label: const Text(
              'Nhắc khách ký',
              style: TextStyle(color: Color(0xFF195AA4), fontWeight: FontWeight.w800),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF195AA4), width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 18),
        TextButton(
          onPressed: () {}, // UI-only
          child: const Text(
            'Hủy yêu cầu này',
            style: TextStyle(
              color: Color(0xFFEF4444),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}