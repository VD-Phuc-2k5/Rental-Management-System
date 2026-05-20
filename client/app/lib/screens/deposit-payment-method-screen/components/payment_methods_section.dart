import 'package:flutter/material.dart';
import 'payment_method_tile.dart';

class PaymentMethodsSection extends StatefulWidget {
  const PaymentMethodsSection({super.key});

  @override
  State<PaymentMethodsSection> createState() => _PaymentMethodsSectionState();
}

class _PaymentMethodsSectionState extends State<PaymentMethodsSection> {
  int selectedIndex = 2; // mặc định chọn "Chuyển khoản ngân hàng"

  void _select(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn phương thức thanh toán',
          style: TextStyle(
            color: Color(0xFF1A202C),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),

        PaymentMethodTile(
          title: 'Ví điện tử MoMo',
          subtitle: 'Miễn phí giao dịch',
          icon: Icons.account_balance_wallet_outlined,
          selected: selectedIndex == 0,
          onTap: () => _select(0),
        ),
        const SizedBox(height: 12),

        PaymentMethodTile(
          title: 'Cổng thanh toán VNPay',
          subtitle: 'Thẻ ATM, QR Code',
          icon: Icons.qr_code_2_rounded,
          selected: selectedIndex == 1,
          onTap: () => _select(1),
        ),
        const SizedBox(height: 12),

        PaymentMethodTile(
          title: 'Chuyển khoản ngân hàng',
          subtitle: 'Ngân hàng',
          icon: Icons.account_balance_rounded,
          selected: selectedIndex == 2,
          onTap: () => _select(2),
        ),
      ],
    );
  }
}