import 'package:flutter/material.dart';

class HeadingTitle extends StatelessWidget {
  const HeadingTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text(
      "Thanh toán thành công",
      style: TextStyle(
        fontFamily: "Inter",
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
    );
  }
}
