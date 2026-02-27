import 'package:flutter/material.dart';

class StepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bước $currentStep/$totalSteps',
          style: const TextStyle(
            color: Color(0xFF1463FF),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(totalSteps, (i) {
            final done = (i + 1) <= currentStep;
            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 8),
                decoration: BoxDecoration(
                  color: done ? const Color(0xFF1463FF) : const Color(0xFFE5E7EB),
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