import 'dart:async';

import '../../core/blocs/new_invoice/new_invoice_cubit.dart';
import '../../core/di/di.dart';
import '../../core/widgets/common_appbar.dart';
import '../../core/widgets/tenant_navigation_bottom.dart';
import '../tenant-invoice-detail-screen/tenant_invoice_detail_screen.dart';
import '../tenant-invoice-payment-screen/tenant_invoice_payment_screen.dart';
import 'components/body.dart';
import 'components/invoice_view_models.dart';
import 'package:domain/billing.dart';
import 'package:flutter/material.dart';
import 'tenant_invoice_mappers.dart';

class TenantInvoiceListScreen extends StatefulWidget {
  const TenantInvoiceListScreen({super.key});

  @override
  State<TenantInvoiceListScreen> createState() => _TenantInvoiceListScreenState();
}

class _TenantInvoiceListScreenState extends State<TenantInvoiceListScreen> {
  InvoiceHistoryState _historyState = InvoiceHistoryState.loading;
  List<InvoiceHistoryItemData> _historyItems = [];
  InvoiceSummaryData? _latestInvoice;
  TenantInvoiceEntity? _latestPayableInvoice;
  String? _errorMessage;
  StreamSubscription<NewInvoiceState>? _invoiceSubscription;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
    _invoiceSubscription = getIt<NewInvoiceCubit>().stream.listen(_onNewInvoice);
    getIt<NewInvoiceCubit>().clearBadge();
  }

  @override
  void dispose() {
    _invoiceSubscription?.cancel();
    super.dispose();
  }

  void _onNewInvoice(NewInvoiceState state) {
    if (state.count > 0) {
      _loadInvoices();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn có hóa đơn mới!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      getIt<NewInvoiceCubit>().clearBadge();
    }
  }

  Future<void> _loadInvoices() async {
    setState(() {
      _historyState = InvoiceHistoryState.loading;
      _errorMessage = null;
    });

    final result = await getIt<GetTenantInvoicesUsecase>().call(
      const GetTenantInvoicesParams(),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _historyState = InvoiceHistoryState.error;
          _errorMessage = failure.toString();
          _historyItems = [];
          _latestInvoice = null;
          _latestPayableInvoice = null;
        });
      },
      (invoices) {
        final sorted = [...invoices]
          ..sort((a, b) => b.month.compareTo(a.month));

        final history = sorted.map(mapTenantInvoiceToHistoryItem).toList();

        TenantInvoiceEntity? latestPayable;
        for (final inv in sorted) {
          if (inv.status == 'finalized') {
            latestPayable = inv;
            break;
          }
        }

        InvoiceSummaryData? summary;
        if (latestPayable != null) {
          summary = InvoiceSummaryData(
            dueDate: formatDueDateDisplay(latestPayable.dueDate),
            amountDue: latestPayable.total,
            billingMonth: formatBillingMonthDisplay(latestPayable.month),
            badgeText: 'Mới nhất',
          );
        }

        setState(() {
          _historyState =
              history.isEmpty ? InvoiceHistoryState.empty : InvoiceHistoryState.data;
          _historyItems = history;
          _latestInvoice = summary;
          _latestPayableInvoice = latestPayable;
        });
      },
    );
  }

  void _navigateToInvoiceDetail(InvoiceHistoryItemData item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TenantInvoiceDetailScreen(invoiceId: item.id),
      ),
    );
  }

  void _navigateToPayment() {
    final payable = _latestPayableInvoice;
    if (payable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có hóa đơn chờ thanh toán.')),
      );
      return;
    }

    final paymentData = mapTenantInvoiceToPayment(payable);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Hóa đơn của tôi'),
      body: Body(
        latestInvoice: _latestInvoice ??
            const InvoiceSummaryData(
              dueDate: '—',
              amountDue: 0,
            ),
        historyState: _historyState,
        historyItems: _historyItems,
        onPayNow: _latestPayableInvoice != null ? _navigateToPayment : null,
        onHistoryItemTap: _navigateToInvoiceDetail,
        historyErrorWidget: _historyState == InvoiceHistoryState.error
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Text(_errorMessage ?? 'Không tải được hóa đơn'),
                    ElevatedButton(
                      onPressed: _loadInvoices,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
            : null,
      ),
      bottomNavigationBar: const TenantNavigationBottom(currentIndex: 3),
    );
  }
}
