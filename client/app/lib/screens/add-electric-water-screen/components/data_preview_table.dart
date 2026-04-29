import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/screens/add-electric-water-screen/models/electric_water_entry.dart';

class DataPreviewTable extends StatelessWidget {
  final List<ElectricWaterEntry> entries;

  const DataPreviewTable({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    // Collect all error messages
    final errors =
        entries.expand((e) => e.errorMessages).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Xem trước dữ liệu',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.blue950,
          ),
        ),
        const SizedBox(height: 10),

        // Table card
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.slate200),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _buildHeaderRow(),
              ...entries.asMap().entries.map(
                (e) => _buildDataRow(e.value, e.key),
              ),
              if (errors.isNotEmpty) _buildErrorBanner(errors),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    const headerStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.slate500,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.slate200)),
      ),
      child: Row(
        children: [
          _headerCell('NHÀ TRỌ', flex: 3, style: headerStyle),
          _headerCell('PHÒNG', flex: 2, style: headerStyle),
          _headerCell('ĐIỆN CŨ', flex: 2, style: headerStyle, align: TextAlign.right),
          _headerCell('ĐIỆN MỚI', flex: 2, style: headerStyle, align: TextAlign.right),
          _headerCell('NƯỚC CŨ', flex: 2, style: headerStyle, align: TextAlign.right),
          _headerCell('NƯỚC MỚI', flex: 2, style: headerStyle, align: TextAlign.right),
        ],
      ),
    );
  }

  Widget _headerCell(
    String text, {
    required int flex,
    required TextStyle style,
    TextAlign align = TextAlign.left,
  }) {
    return Expanded(
      flex: flex,
      child: Text(text, style: style, textAlign: align),
    );
  }

  Widget _buildDataRow(ElectricWaterEntry entry, int index) {
    final isError = entry.hasError;
    final isEven = index.isEven;

    Color rowBg;
    if (isError) {
      rowBg = AppColors.red50;
    } else if (!isEven) {
      rowBg = AppColors.slate50;
    } else {
      rowBg = AppColors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: rowBg,
        border: const Border(bottom: BorderSide(color: AppColors.slate200, width: 0.5)),
      ),
      child: Row(
        children: [
          // NHÀ TRỌ
          Expanded(
            flex: 3,
            child: Text(
              entry.hostelName,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.slate700,
              ),
            ),
          ),
          // PHÒNG
          Expanded(
            flex: 2,
            child: Text(
              entry.roomNumber,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.blue950,
              ),
            ),
          ),
          // ĐIỆN CŨ
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(entry.oldElectric),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.slate600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // ĐIỆN MỚI
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(entry.newElectric),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    entry.hasElectricError
                        ? AppColors.red600
                        : AppColors.blue500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // NƯỚC CŨ
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(entry.oldWater),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.slate600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // NƯỚC MỚI
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(entry.newWater),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    entry.hasWaterError ? AppColors.red600 : AppColors.blue500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(List<String> errors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: AppColors.red50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: errors
            .map(
              (msg) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 16,
                      color: AppColors.orange600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        msg,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.red700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _formatNumber(int value) {
    // Format: 1350 -> 1,350
    final str = value.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join();
  }
}
