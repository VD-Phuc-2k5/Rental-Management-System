import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/screens/preview-invoice/components/info_banner.dart';
import 'package:app/screens/preview-invoice/components/invoice_bottom_bar.dart';
import 'package:app/screens/preview-invoice/components/invoice_card.dart';
import 'package:app/core/models/invoice_preview.dart';

class PreviewContractBody extends StatefulWidget {
  final List<InvoicePreview> invoices;

  const PreviewContractBody({super.key, required this.invoices});

  @override
  State<PreviewContractBody> createState() => _PreviewContractBodyState();
}

class _PreviewContractBodyState extends State<PreviewContractBody> {
  late final Set<String> _selectedIds;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.invoices.map((e) => e.id).toSet();
  }

  bool get _allSelected => _selectedIds.length == widget.invoices.length;

  int get _totalAmount => widget.invoices
      .where((e) => _selectedIds.contains(e.id))
      .fold(0, (sum, e) => sum + e.total);

  void _toggleAll(bool? value) {
    setState(() {
      if (value == true) {
        _selectedIds.addAll(widget.invoices.map((e) => e.id));
      } else {
        _selectedIds.clear();
      }
    });
  }

  void _toggleOne(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  // TODO: Gọi API gửi hóa đơn cho các phòng được chọn
  Future<void> _onSend() async {
    setState(() => _isSending = true);

    // TODO: await invoiceApi.sendInvoices(
    //   widget.invoices
    //     .where((e) => _selectedIds.contains(e.id))
    //     .map((e) => e.id)
    //     .toList(),
    // );
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSending = false);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoBanner(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _toggleAll(!_allSelected),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _allSelected
                                  ? AppColors.blue700
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _allSelected
                                    ? AppColors.blue700
                                    : AppColors.slate400,
                                width: 1.5,
                              ),
                            ),
                            child: _allSelected
                                ? const Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                    size: 14,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Chọn tất cả (${widget.invoices.length})',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue950,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: open filter bottom sheet
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.blue700,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 32),
                      ),
                      child: const Text(
                        'Lọc',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...widget.invoices.map(
                  (invoice) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InvoiceCard(
                      invoice: invoice,
                      isSelected: _selectedIds.contains(invoice.id),
                      onToggleSelect: (val) => _toggleOne(invoice.id, val),
                      onEdit: () {
                        // TODO: navigate to edit invoice screen
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        InvoiceBottomBar(
          selectedCount: _selectedIds.length,
          totalAmount: _totalAmount,
          onSend: _onSend,
          isLoading: _isSending,
        ),
      ],
    );
  }
}
