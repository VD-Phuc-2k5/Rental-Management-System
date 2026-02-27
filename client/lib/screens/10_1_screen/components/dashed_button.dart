import 'package:flutter/material.dart';

class DashedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DashedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1463FF),
            width: 1.4,
          ),
          color: Colors.white,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1463FF),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}