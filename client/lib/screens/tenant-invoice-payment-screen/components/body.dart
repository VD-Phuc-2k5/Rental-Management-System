import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:app/screens/tenant-invoice-payment-screen/components/payment_method_selector.dart';
import 'package:app/screens/tenant-invoice-payment-screen/components/payment_models.dart';
import 'package:app/screens/tenant-invoice-payment-screen/components/payment_summary_card.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final PaymentData paymentData;
  final VoidCallback? onPaymentSubmit;

  const Body({super.key, required this.paymentData, this.onPaymentSubmit});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PaymentMethodType _selectedMethod = PaymentMethodType.vnpay;

  List<PaymentMethodOption> get _paymentMethods => [
    PaymentMethodOption(
      type: PaymentMethodType.vnpay,
      name: "VNPay",
      description: "Thanh toán qua ứng dụng ngân hàng",
      iconName: "qr_code",
      isSelected: _selectedMethod == PaymentMethodType.vnpay,
    ),
    PaymentMethodOption(
      type: PaymentMethodType.momo,
      name: "MoMo",
      description: "Ví điện tử momo",
      iconName: "wallet",
      isSelected: _selectedMethod == PaymentMethodType.momo,
    ),
  ];

  void _handleMethodSelected(PaymentMethodType method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  void _handlePaymentSubmit() {
    // Callback to parent component with selected payment method
    widget.onPaymentSubmit?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        spacing: 24.0,
        children: [
          PaymentSummaryCard(
            lineItems: widget.paymentData.lineItems,
            totalAmount: widget.paymentData.totalAmount,
          ),
          Expanded(
            child: PaymentMethodSelector(
              paymentMethods: _paymentMethods,
              onMethodSelected: _handleMethodSelected,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handlePaymentSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue700,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                "Thanh toán ${formatVND(widget.paymentData.totalAmount)}",
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
