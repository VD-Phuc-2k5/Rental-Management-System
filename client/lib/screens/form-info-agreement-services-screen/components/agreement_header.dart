import 'package:flutter/material.dart';

class AgreementHeader extends StatelessWidget {
  final int step;
  final int total;

  const AgreementHeader({
    super.key,
    required this.step,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bước $step/$total',
          style: const TextStyle(
            color: Color(0xFF195AA4),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(total, (i) {
            final done = (i + 1) <= step;
            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(right: i == total - 1 ? 0 : 8),
                decoration: BoxDecoration(
                  color: done ? const Color(0xFF195AA4) : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}