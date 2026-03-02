import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/constants.dart';

class RentPriceSectionUi extends StatefulWidget {
  final TextEditingController rentPriceCtl;
  final TextEditingController startDateCtl;

  final List<String> terms;
  final String initialTerm;
  final ValueChanged<String>? onTermChanged;

  RentPriceSectionUi({
    super.key,
    required this.rentPriceCtl,
    required this.startDateCtl,
    List<String> terms = const ['6 tháng', '12 tháng', '18 tháng', '24 tháng'],
    String? initialTerm,
    this.onTermChanged,
  }): terms = terms,
      initialTerm =
          (initialTerm != null && terms.contains(initialTerm))
              ? initialTerm
              : terms.first;

  @override
  State<RentPriceSectionUi> createState() => _RentPriceSectionUiState();
}

class _RentPriceSectionUiState extends State<RentPriceSectionUi> {
  late String _term;

  @override
  void initState() {
    super.initState();
    _term = widget.initialTerm;
  }

  @override
  Widget build(BuildContext context) {
    return _CardWrap(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MiniLabel('Giá thuê/tháng'),
          const SizedBox(height: 8),

          _PillMoneyInput(
            controller: widget.rentPriceCtl,
            hint: 'Nhập số tiền',
            suffix: 'VND',
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _MiniLabel('Ngày bắt đầu'),
                    const SizedBox(height: 8),
                    _PillInput(
                      controller: widget.startDateCtl,
                      hint: 'dd/mm/yyyy',
                      keyboardType: TextInputType.datetime,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _MiniLabel('Thời hạn'),
                    const SizedBox(height: 8),

                    _PillDropdown(
                      value: _term,
                      items: widget.terms,
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _term = v);
                        widget.onTermChanged?.call(v);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardWrap extends StatelessWidget {
  final Widget child;
  const _CardWrap({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );
  }
}

class _MiniLabel extends StatelessWidget {
  final String text;
  const _MiniLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF6B7280),
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }
}

class _PillInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _PillInput({
    required this.controller,
    this.hint = 'dd/mm/yyyy',
    this.keyboardType = TextInputType.datetime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.gray900,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.gray900,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _PillMoneyInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String suffix;

  const _PillMoneyInput({
    required this.controller,
    required this.suffix,
    this.hint = 'Nhập số tiền',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandDotFormatter(),
              ],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.gray900,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9CA3AF),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            suffix,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _PillDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF6B7280),
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.gray900,
            fontSize: 16,
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class ThousandDotFormatter extends TextInputFormatter {
  static String _format(String digits) {
    if (digits.isEmpty) return '';
    digits = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');

    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final indexFromRight = digits.length - i;
      buf.write(digits[i]);
      if (indexFromRight > 1 && indexFromRight % 3 == 1) {
        buf.write('.');
      }
    }
    return buf.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    //giữ số
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final formatted = _format(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}