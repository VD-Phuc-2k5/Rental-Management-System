import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import '../../core/models/invoice_preview.dart';
import 'package:flutter/material.dart';

class PreviewInvoiceScreen extends StatelessWidget {
  const PreviewInvoiceScreen({
    super.key,
    required this.month,
    required this.monthLabel,
    required this.invoices,
    this.propertyId,
  });
  final String month;
  final String monthLabel;
  final String? propertyId;

  final List<InvoicePreview> invoices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(
        title: 'Xem trước hóa đơn',
        badge: CommonAppBarBadge(
          text: '$monthLabel • ${invoices.length} phòng',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Hủy',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppColors.blue700,
              ),
            ),
          ),
        ],
      ),
      body: PreviewInvoceBody(
        invoices: invoices,
        month: month,
        monthLabel: monthLabel,
        propertyId: propertyId,
      ),
    );
  }
}
