import '../../core/di/di.dart';
import '../../core/widgets/common_appbar.dart';
import '../tenant-invoice-payment-screen/tenant_invoice_payment_screen.dart';
import 'components/body.dart';
import 'components/invoice_detail_models.dart';
import 'package:domain/billing.dart';
import 'package:flutter/material.dart';
import '../tenant-invoice-list-screen/tenant_invoice_mappers.dart';

class TenantInvoiceDetailScreen extends StatefulWidget {
  const TenantInvoiceDetailScreen({
    super.key,
    required this.invoiceId,
  });

  final String invoiceId;

  @override
  State<TenantInvoiceDetailScreen> createState() =>
      _TenantInvoiceDetailScreenState();
}

class _TenantInvoiceDetailScreenState extends State<TenantInvoiceDetailScreen> {
  bool _loading = true;
  String? _errorMessage;
  InvoiceDetailData? _invoice;
  TenantInvoiceDetailEntity? _rawInvoice;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final result = await getIt<GetInvoiceDetailUsecase>().call(
      GetInvoiceDetailParams(invoiceId: widget.invoiceId),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _loading = false;
          _errorMessage = failure.toString();
          _invoice = null;
          _rawInvoice = null;
        });
      },
      (detail) {
        setState(() {
          _loading = false;
          _rawInvoice = detail;
          _invoice = mapTenantInvoiceDetailToUi(detail);
        });
      },
    );
  }

  void _handlePayNow() {
    final raw = _rawInvoice;
    if (raw == null) return;

    if (raw.status != 'finalized') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hóa đơn này không ở trạng thái chờ thanh toán.'),
        ),
      );
      return;
    }

    final paymentData = mapTenantInvoiceDetailToPayment(raw);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TenantInvoicePaymentScreen(
          appbarTitle: 'Thanh toán hóa đơn',
          paymentData: paymentData,
        ),
      ),
    );
  }

  void _handleDownloadPDF() {
    // TO DO: Implement PDF download logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Chi tiết hóa đơn'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Text(_errorMessage!),
                  ElevatedButton(
                    onPressed: _loadDetail,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            )
          : _invoice != null
          ? Body(
              invoice: _invoice!,
              onPayNow: _rawInvoice?.status == 'finalized' ? _handlePayNow : null,
              onDownloadPDF: _handleDownloadPDF,
            )
          : const SizedBox.shrink(),
    );
  }
}
