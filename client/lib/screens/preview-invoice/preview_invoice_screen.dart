import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/preview-invoice/components/body.dart';
import 'package:app/core/models/invoice_preview.dart';
import 'package:flutter/material.dart';

class PreviewInvoiceScreen extends StatelessWidget {
  final String monthLabel;

  final List<InvoicePreview> invoices;

  const PreviewInvoiceScreen({
    super.key,
    required this.monthLabel,
    required this.invoices,
  });

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
      body: PreviewInvoceBody(invoices: invoices),
    );
  }
}
