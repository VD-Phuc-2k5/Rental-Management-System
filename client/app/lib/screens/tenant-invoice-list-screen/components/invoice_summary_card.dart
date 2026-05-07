import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/invoice_view_models.dart';

class InvoiceSummaryCard extends StatelessWidget {
  final InvoiceSummaryData invoice;
  final VoidCallback? onPayNow;

  const InvoiceSummaryCard({super.key, required this.invoice, this.onPayNow});

  String _getBillingMonth(String invoiceDueDate) {
    final DateTime date = DateFormat('dd/MM/yyyy').parse(invoiceDueDate);
    final DateTime billingDate = DateTime(date.year, date.month - 1);
    return DateFormat('MM/yyyy').format(billingDate);
  }

  @override
  Widget build(BuildContext context) {
    const invoiceLabelStyle = TextStyle(
      color: AppColors.white,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: const LinearGradient(
          colors: [AppColors.blue700, AppColors.blue300],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(26),
            blurRadius: 6,
            spreadRadius: -4,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.black.withAlpha(26),
            blurRadius: 15,
            spreadRadius: -3,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        spacing: 16.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    'Hạn thanh toán: ${invoice.dueDate}',
                    style: invoiceLabelStyle,
                  ),
                  Text(
                    'Tháng ${_getBillingMonth(invoice.dueDate)}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      letterSpacing: -0.6,
                    ),
                  ),
                ],
              ),
              if (invoice.badgeText != null)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1.0,
                      color: AppColors.white.withAlpha(13),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    invoice.badgeText!,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tổng thanh toán', style: invoiceLabelStyle),
                Text(
                  formatVND(invoice.amountDue),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                    letterSpacing: -0.9,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.white.withAlpha(51),
                  width: 1.0,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.white),
              onPressed: onPayNow,
              child: const Text(
                'Thanh toán ngay',
                style: TextStyle(
                  color: AppColors.blue700,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
