import 'package:flutter/material.dart';

import '../../core/widgets/landlord_navigation_bottom.dart';
import 'components/body.dart';
import 'components/landlord_payment_history_app_bar.dart';

class LandlordPaymentHistoryScreen extends StatefulWidget {
  const LandlordPaymentHistoryScreen({super.key});

  @override
  State<LandlordPaymentHistoryScreen> createState() =>
      _LandlordPaymentHistoryScreenState();
}

class _LandlordPaymentHistoryScreenState
    extends State<LandlordPaymentHistoryScreen> {
  String? _selectedMonth;

  late final List<String> _monthOptions = _buildMonthOptions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LandlordPaymentHistoryAppBar(
        selectedMonth: _selectedMonth,
        monthOptions: _monthOptions,
        onMonthChanged: (value) => setState(() => _selectedMonth = value),
      ),
      body: LandlordPaymentHistoryBody(month: _selectedMonth),
      bottomNavigationBar: const LandlordNavigationBottom(currentIndex: 3),
    );
  }

  List<String> _buildMonthOptions() {
    final now = DateTime.now();
    return List.generate(13, (index) {
      final date = DateTime(now.year, now.month - index);
      final month = date.month.toString().padLeft(2, '0');
      return '${date.year}-$month';
    });
  }
}
