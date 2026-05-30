import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants.dart';

class PenaltyDialog extends StatefulWidget {
  const PenaltyDialog({super.key});

  @override
  State<PenaltyDialog> createState() => _PenaltyDialogState();
}

class _PenaltyDialogState extends State<PenaltyDialog> {
  final _reasonController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      title: const Text('Lập phiếu phạt', style: TextStyle(color: AppColors.blue900, fontWeight: FontWeight.bold, fontSize: 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lý do vi phạm:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'VD: Ồn ào sau 22h, xả rác...', isDense: true),
          ),
          const SizedBox(height: 16),
          const Text('Số tiền phạt (VND):', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'VD: 100000', isDense: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(color: AppColors.slate500)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.red500, foregroundColor: Colors.white),
          onPressed: () {
            final reason = _reasonController.text.trim();
            final amount = double.tryParse(_amountController.text.trim()) ?? 0;
            if (reason.isNotEmpty && amount > 0) {
              Navigator.pop(context, {'reason': reason, 'amount': amount}); // Trả kết quả về
            }
          },
          child: const Text('Xác nhận phạt'),
        ),
      ],
    );
  }
}