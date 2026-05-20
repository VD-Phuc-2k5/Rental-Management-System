import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:app/screens/tenant-invoice-payment-screen/components/payment_models.dart';
import 'package:flutter/material.dart';

class PaymentSummaryCard extends StatelessWidget {
  final List<PaymentLineItemData> lineItems;
  final int totalAmount;

  const PaymentSummaryCard({
    super.key,
    required this.lineItems,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 2.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        spacing: 16.0,
        children: [_buildHeader(), _buildLineItems()],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: AppColors.slate100),
        ),
      ),
      child: Column(
        spacing: 4.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chi tiết thanh toán",
            style: TextStyle(
              color: AppColors.slate500,
              fontFamily: "Inter",
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.left,
          ),
          Text(
            formatVND(totalAmount),
            style: const TextStyle(
              color: AppColors.blue700,
              fontFamily: "Inter",
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineItems() {
    return Column(
      spacing: 12.0,
      children: lineItems.map((item) => _buildLineItem(item)).toList(),
    );
  }

  Widget _buildLineItem(PaymentLineItemData item) {
    const labelStyle = TextStyle(
      color: AppColors.slate600,
      fontFamily: "Inter",
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    const descriptionStyle = TextStyle(
      color: AppColors.slate400,
      fontFamily: "Inter",
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    const valueStyle = TextStyle(
      color: AppColors.blue950,
      fontFamily: "Inter",
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (item.description != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: labelStyle),
              Text(item.description!, style: descriptionStyle),
            ],
          )
        else
          Text(item.name, style: labelStyle),
        Text(formatVND(item.amount), style: valueStyle),
      ],
    );
  }
}
