import 'package:flutter/material.dart';

class TenantInfoHeader extends StatelessWidget {
  final int step;
  final int total;

  const TenantInfoHeader({
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
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _StepBar(current: step, total: total),
        const SizedBox(height: 14),
        const _SectionTitle(text: 'THÔNG TIN KHÁCH THUÊ'),
      ],
    );
  }
}

class _StepBar extends StatelessWidget {
  final int current;
  final int total;

  const _StepBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final done = (i + 1) <= current;
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
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF195AA4),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }
}