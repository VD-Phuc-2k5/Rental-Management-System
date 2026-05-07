import 'package:app/core/constants.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/invoice_item.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/invoice_view_models.dart';
import 'package:flutter/material.dart';

class InvoiceHistorySection extends StatelessWidget {
  final InvoiceHistoryState state;
  final List<InvoiceHistoryItemData> items;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<InvoiceHistoryItemData>? onItemTap;
  final String searchHint;
  final Widget? errorWidget;

  const InvoiceHistorySection({
    super.key,
    required this.state,
    required this.items,
    this.onSearchChanged,
    this.onItemTap,
    this.searchHint = 'Tìm kiếm hóa đơn...',
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          const Text(
            'Lịch sử hóa đơn',
            style: TextStyle(
              color: AppColors.blue950,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: searchHint,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  width: 1,
                  color: AppColors.blue600,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  width: 1,
                  color: AppColors.blue600,
                ),
              ),
            ),
          ),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (state) {
      case InvoiceHistoryState.loading:
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(),
          ),
        );
      case InvoiceHistoryState.error:
        return errorWidget ??
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Không thể tải danh sách hóa đơn.',
                style: TextStyle(
                  color: AppColors.red600,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            );
      case InvoiceHistoryState.empty:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Chưa có hóa đơn nào.',
            style: TextStyle(
              color: AppColors.slate500,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        );
      case InvoiceHistoryState.data:
        return Column(
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InvoiceItem(
                    billingMonth: item.billingMonth,
                    paidAt: item.paidAt,
                    amount: item.amount,
                    statusLabel: item.statusLabel,
                    isPaid: item.isPaid,
                    onTap: onItemTap != null ? () => onItemTap!(item) : null,
                  ),
                ),
              )
              .toList(),
        );
    }
  }
}
