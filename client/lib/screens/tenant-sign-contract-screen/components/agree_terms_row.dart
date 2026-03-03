import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class AgreeTermsRow extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const AgreeTermsRow({
    super.key,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<AgreeTermsRow> createState() => _AgreeTermsRowState();
}

class _AgreeTermsRowState extends State<AgreeTermsRow> {
  late bool agreed;

  @override
  void initState() {
    super.initState();
    agreed = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant AgreeTermsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        agreed = widget.initialValue;
      });
    }
  }

  void _toggle() {
    setState(() => agreed = !agreed);
    widget.onChanged?.call(agreed);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CheckBoxCircle(
          value: agreed,
          onTap: _toggle,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: const Text.rich(
              TextSpan(
                style: TextStyle(
                  color: AppColors.slate600,
                  height: 1.25,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(text: 'Tôi xác nhận đã đọc kỹ và đồng ý với tất cả\n'),
                  TextSpan(
                    text: 'điều khoản hợp đồng',
                    style: TextStyle(
                      color: AppColors.blue700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' nêu trên.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckBoxCircle extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;

  const _CheckBoxCircle({
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: value ? AppColors.blue700 : AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: value ? AppColors.blue700 : AppColors.slate300,
          ),
        ),
        child: value
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}