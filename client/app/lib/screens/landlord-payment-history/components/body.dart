import 'package:domain/billing.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/di/di.dart';
import '../../tenant-invoice-detail-screen/tenant_invoice_detail_screen.dart';
import 'payment_summary_card.dart';
import 'transaction_list_item.dart';

class LandlordPaymentHistoryBody extends StatefulWidget {
  const LandlordPaymentHistoryBody({super.key, this.month});

  final String? month;

  @override
  State<LandlordPaymentHistoryBody> createState() =>
      _LandlordPaymentHistoryBodyState();
}

class _LandlordPaymentHistoryBodyState
    extends State<LandlordPaymentHistoryBody> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _loading = true;
  String? _errorMessage;
  List<TenantInvoiceEntity> _invoices = [];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  @override
  void didUpdateWidget(covariant LandlordPaymentHistoryBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.month != widget.month) {
      _loadInvoices();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInvoices() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final result = await getIt<GetLandlordInvoicesUsecase>().call(
      GetLandlordInvoicesParams(month: widget.month),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _loading = false;
          _errorMessage = failure.toString();
        });
      },
      (data) {
        final sorted = [...data]..sort((a, b) => b.month.compareTo(a.month));
        setState(() {
          _loading = false;
          _invoices = sorted;
        });
      },
    );
  }

  List<TenantInvoiceEntity> get _filteredInvoices {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _invoices;
    return _invoices
        .where(
          (i) => '${i.roomId} ${i.month} ${i.status}'.toLowerCase().contains(q),
        )
        .toList();
  }

  int get _totalCollected => _invoices
      .where((i) => i.status == 'paid')
      .fold(0, (sum, i) => sum + i.total);

  int get _totalUncollected => _invoices
      .where((i) => i.status != 'paid' && i.status != 'void')
      .fold(0, (sum, i) => sum + i.total);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_errorMessage!, textAlign: TextAlign.center),
            ),
            ElevatedButton(
              onPressed: _loadInvoices,
              child: const Text('Thu lai'),
            ),
          ],
        ),
      );
    }

    final invoices = _filteredInvoices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaymentSummaryCard(
          totalCollected: _totalCollected,
          totalUncollected: _totalUncollected,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Tim theo phong, thang, trang thai',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.gray200),
              ),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadInvoices,
            child: invoices.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 96),
                      Center(
                        child: Text(
                          'Chua co hoa don nao.',
                          style: TextStyle(color: AppColors.slate500),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      final paid = invoice.status == 'paid';
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TenantInvoiceDetailScreen(
                              invoiceId: invoice.id,
                            ),
                          ),
                        ),
                        child: TransactionListItem(
                          roomName: _roomLabel(invoice.roomId),
                          tenantName: _statusLabel(invoice.status),
                          paymentMethod: paid ? 'VNPay/PayOS' : '',
                          timeOrDeadline: paid
                              ? _dateLabel(invoice.paidAt)
                              : _dueLabel(invoice.dueDate),
                          amount: invoice.total,
                          status: paid
                              ? TransactionStatus.paid
                              : TransactionStatus.pending,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  String _roomLabel(String roomId) {
    if (roomId.length <= 8) return 'Phong $roomId';
    return 'Phong ${roomId.substring(0, 8)}';
  }

  String _statusLabel(String status) {
    return switch (status) {
      'draft' => 'Nhap',
      'finalized' => 'Cho thanh toan',
      'paid' => 'Da thanh toan',
      'void' => 'Da huy',
      _ => status,
    };
  }

  String _dueLabel(String? dueDate) {
    if (dueDate == null || dueDate.isEmpty) return 'Chua dat han';
    return dueDate;
  }

  String _dateLabel(DateTime? value) {
    if (value == null) return '';
    return value.toLocal().toString().split('.').first;
  }
}
