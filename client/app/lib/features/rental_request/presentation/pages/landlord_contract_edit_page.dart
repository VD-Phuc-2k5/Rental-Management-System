import 'package:domain/rental_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';

class LandlordContractEditPage extends StatelessWidget {
  const LandlordContractEditPage({super.key, required this.contract});

  final ContractEntity contract;

  @override
  Widget build(BuildContext context) {
    return _LandlordContractEditView(contract: contract);
  }
}

class _LandlordContractEditView extends StatefulWidget {
  const _LandlordContractEditView({required this.contract});

  final ContractEntity contract;

  @override
  State<_LandlordContractEditView> createState() =>
      _LandlordContractEditViewState();
}

class _LandlordContractEditViewState extends State<_LandlordContractEditView> {
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _rentController;
  late final TextEditingController _depositController;
  late final TextEditingController _termsController;

  bool _isSaving = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController(
      text: widget.contract.startDate.substring(0, 10),
    );
    _endDateController = TextEditingController(
      text: widget.contract.endDate.substring(0, 10),
    );
    _rentController = TextEditingController(
      text: widget.contract.monthlyRent.toStringAsFixed(0),
    );
    _depositController = TextEditingController(
      text: widget.contract.deposit.toStringAsFixed(0),
    );
    _termsController = TextEditingController(text: widget.contract.terms ?? '');
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final current = DateTime.tryParse(controller.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  UpdateContractParams _buildParams() {
    return UpdateContractParams(
      id: widget.contract.id,
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
      monthlyRent: double.tryParse(_rentController.text.trim()),
      deposit: double.tryParse(_depositController.text.trim()),
      terms: _termsController.text.trim().isEmpty
          ? null
          : _termsController.text.trim(),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final result = await getIt<UpdateContractUsecase>().call(_buildParams());
    if (!mounted) return;
    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.toString()))),
      (_) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã lưu thay đổi'))),
    );
    setState(() => _isSaving = false);
  }

  Future<void> _send() async {
    setState(() => _isSending = true);
    final updateResult = await getIt<UpdateContractUsecase>().call(
      _buildParams(),
    );
    if (!mounted) return;
    final didUpdate = updateResult.isRight();
    if (!didUpdate) {
      updateResult.fold(
        (failure) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.toString()))),
        (_) {},
      );
      setState(() => _isSending = false);
      return;
    }
    final sendResult = await getIt<SendContractUsecase>().call(
      SendContractParams(id: widget.contract.id),
    );
    if (!mounted) return;
    sendResult.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.toString()))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi hợp đồng cho thuê nhân!')),
        );
        context.pop();
      },
    );
    if (mounted) setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isSaving || _isSending;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue700),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Chỉnh sửa hợp đồng',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateField(
              label: 'Ngày bắt đầu',
              controller: _startDateController,
              onTap: () => _pickDate(_startDateController),
            ),
            const SizedBox(height: 16),
            _DateField(
              label: 'Ngày kết thúc',
              controller: _endDateController,
              onTap: () => _pickDate(_endDateController),
            ),
            const SizedBox(height: 16),
            _NumberField(
              label: 'Tiền thuê hàng tháng (VNĐ)',
              controller: _rentController,
            ),
            const SizedBox(height: 16),
            _NumberField(
              label: 'Tiền đặt cọc (VNĐ)',
              controller: _depositController,
            ),
            const SizedBox(height: 16),
            _TermsField(controller: _termsController),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: isLoading ? null : _save,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.blue700,
                    side: const BorderSide(color: AppColors.blue700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.blue700,
                          ),
                        )
                      : const Text(
                          'Lưu thay đổi',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isSending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Gửi hợp đồng',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.controller,
    required this.onTap,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.slate500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.slate300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.blue700),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.slate500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.slate300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.blue700),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _TermsField extends StatelessWidget {
  const _TermsField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Điều khoản hợp đồng (tuỳ chọn)',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.slate500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Nhập điều khoản...',
            hintStyle: const TextStyle(color: AppColors.slate400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.slate300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.blue700),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
