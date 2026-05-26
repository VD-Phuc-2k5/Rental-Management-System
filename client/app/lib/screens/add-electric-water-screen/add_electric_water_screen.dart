import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';

class AddElectricWaterScreen extends StatefulWidget {
  const AddElectricWaterScreen({super.key});

  @override
  State<AddElectricWaterScreen> createState() => _AddElectricWaterScreenState();
}

class _AddElectricWaterScreenState extends State<AddElectricWaterScreen> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  String get _monthValue {
    final month = _selectedMonth.month.toString().padLeft(2, '0');
    return '${_selectedMonth.year}-$month';
  }

  String get _monthLabel {
    final month = _selectedMonth.month.toString().padLeft(2, '0');
    return 'THANG $month/${_selectedMonth.year}';
  }

  void _handleMonthChanged(DateTime value) {
    setState(() {
      _selectedMonth = DateTime(value.year, value.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(
        title: "Nhap chi so dien - nuoc", 
        badge: CommonAppBarBadge(
          text: _monthLabel,
        ),
      ),
      body: AddElectricWaterBody(
        month: _monthValue,
        monthLabel: _monthLabel,
        onMonthChanged: _handleMonthChanged,
      ),
    );
  }
}