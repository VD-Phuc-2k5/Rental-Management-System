import 'package:flutter/material.dart';

class DepositSection extends StatelessWidget {
  const DepositSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiền đặt cọc',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.payments_outlined, color: Color(0xFF195AA4)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '3.000.000',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text('VND', style: TextStyle(color: Color(0xFF647487), fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Số tiền này sẽ được ghi nhận vào biên lai thu tiền cọc.',
                  style: TextStyle(color: Color(0xFF647487)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}