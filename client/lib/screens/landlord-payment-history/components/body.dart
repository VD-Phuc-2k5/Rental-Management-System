import 'package:app/core/constants.dart';
import 'package:app/screens/landlord-payment-history/components/payment_summary_card.dart';
import 'package:app/screens/landlord-payment-history/components/transaction_list_item.dart';
import 'package:flutter/material.dart';

class LandlordPaymentHistoryBody extends StatefulWidget {
  const LandlordPaymentHistoryBody({super.key});

  @override
  State<LandlordPaymentHistoryBody> createState() =>
      _LandlordPaymentHistoryBodyState();
}

class _LandlordPaymentHistoryBodyState
    extends State<LandlordPaymentHistoryBody> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<Map<String, dynamic>> _paidTransactions = [
    {
      'roomName': 'Phòng 101',
      'tenantName': 'Nguyễn Văn A',
      'paymentMethod': 'VNPay',
      'time': '08:30 hôm nay',
      'amount': 2972500,
    },
    {
      'roomName': 'Phòng 205',
      'tenantName': 'Trần Thị B',
      'paymentMethod': 'MoMo',
      'time': '17:45 hôm qua',
      'amount': 3500000,
    },
    {
      'roomName': 'Phòng 205',
      'tenantName': 'Trần Thị B',
      'paymentMethod': 'MoMo',
      'time': '17:45 hôm qua',
      'amount': 3500000,
    },
    {
      'roomName': 'Phòng 205',
      'tenantName': 'Trần Thị B',
      'paymentMethod': 'MoMo',
      'time': '17:45 hôm qua',
      'amount': 3500000,
    },
  ];

  static const List<Map<String, dynamic>> _pendingTransactions = [
    {
      'roomName': 'Phòng 102',
      'tenantName': 'Chưa thu',
      'deadline': '20/10/2023',
      'amount': 2500000,
    },
  ];

  List<Map<String, dynamic>> get _filteredPaid => _paidTransactions
      .where((t) =>
          '${t['roomName']} ${t['tenantName']}'
              .toLowerCase()
              .contains(_query.toLowerCase()))
      .toList();

  List<Map<String, dynamic>> get _filteredPending => _pendingTransactions
      .where((t) =>
          '${t['roomName']} ${t['tenantName']}'
              .toLowerCase()
              .contains(_query.toLowerCase()))
      .toList();

  int get _totalCollected =>
      _paidTransactions.fold(0, (sum, t) => sum + (t['amount'] as int));
  int get _totalUncollected =>
      _pendingTransactions.fold(0, (sum, t) => sum + (t['amount'] as int));

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paid = _filteredPaid;
    final pending = _filteredPending;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaymentSummaryCard(
          totalCollected: _totalCollected,
          totalUncollected: _totalUncollected,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  'Giao dịch gần đây',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.gray800),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm hóa đơn',
                    hintStyle: const TextStyle(
                        fontSize: 14, color: AppColors.slate400),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.slate400, size: 20),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    filled: true,
                    fillColor: AppColors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.gray200, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.blue400, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (paid.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Không tìm thấy giao dịch.',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.slate400),
                  ),
                )
              else
                ...paid.asMap().entries.map((entry) {
                  final t = entry.value;
                  return Column(
                    children: [
                      TransactionListItem(
                        roomName: t['roomName'],
                        tenantName: t['tenantName'],
                        paymentMethod: t['paymentMethod'],
                        timeOrDeadline: t['time'],
                        amount: t['amount'],
                        status: TransactionStatus.paid,
                      ),
                      if (entry.key < paid.length - 1)
                        const Divider(
                          height: 1,
                          indent: 72,
                          endIndent: 16,
                          color: AppColors.gray100,
                        ),
                    ],
                  );
                }),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
                child: Text(
                  'Chưa thanh toán',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate900,
                    fontFamily: "Inter",
                  ),
                ),
              ),

              if (pending.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Không có hóa đơn chưa thanh toán.',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.slate400),
                  ),
                )
              else
                ...pending.asMap().entries.map((entry) {
                  final t = entry.value;
                  return Column(
                    children: [
                      TransactionListItem(
                        roomName: t['roomName'],
                        tenantName: t['tenantName'],
                        paymentMethod: '',
                        timeOrDeadline: t['deadline'],
                        amount: t['amount'],
                        status: TransactionStatus.pending,
                      ),
                      if (entry.key < pending.length - 1)
                        const Divider(
                          height: 1,
                          indent: 72,
                          endIndent: 16,
                          color: AppColors.gray100,
                        ),
                    ],
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}