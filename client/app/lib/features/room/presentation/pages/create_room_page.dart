import 'package:app/core/constants.dart';
import 'package:app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/create_room/create_room_bloc.dart';

class CreateRoomPage extends StatelessWidget {
  const CreateRoomPage({super.key, required this.propertyId});
  final String propertyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateRoomBloc>(),
      child: _CreateRoomView(propertyId: propertyId),
    );
  }
}

class _CreateRoomView extends StatefulWidget {
  const _CreateRoomView({required this.propertyId});
  final String propertyId;
  @override
  State<_CreateRoomView> createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends State<_CreateRoomView> {
  final _titleCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _rentCtrl = TextEditingController();
  final _depositCtrl = TextEditingController();
  final _elecCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _hasFurniture = false;

  @override
  void dispose() {
    _titleCtrl.dispose(); _areaCtrl.dispose(); _rentCtrl.dispose();
    _depositCtrl.dispose(); _elecCtrl.dispose(); _waterCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.slate700)),
  );

  Widget _field(TextEditingController ctrl, String hint, {String? suffix, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) => TextFormField(
    controller: ctrl,
    maxLines: maxLines,
    keyboardType: keyboardType,
    style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.slate900),
    decoration: InputDecoration(
      hintText: hint,
      filled: true, fillColor: AppColors.slate50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      suffixText: suffix,
      suffixStyle: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.slate400),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.slate200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blue700)),
    ),
  );

  void _submit() {
    final title = _titleCtrl.text.trim();
    final area = double.tryParse(_areaCtrl.text.trim());
    final rent = double.tryParse(_rentCtrl.text.trim().replaceAll('.', ''));
    final deposit = double.tryParse(_depositCtrl.text.trim().replaceAll('.', ''));
    final elec = double.tryParse(_elecCtrl.text.trim().replaceAll('.', ''));
    final water = double.tryParse(_waterCtrl.text.trim().replaceAll('.', ''));

    if (title.isEmpty || area == null || rent == null || deposit == null || elec == null || water == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đầy đủ và đúng định dạng số')));
      return;
    }
    context.read<CreateRoomBloc>().add(CreateRoomSubmitted(
      propertyId: widget.propertyId,
      title: title, areaSqm: area,
      monthlyRent: rent, depositAmount: deposit,
      electricityRatePerKwh: elec, waterRatePerM3: water,
      hasFurniture: _hasFurniture,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRoomBloc, CreateRoomState>(
      listener: (context, state) {
        if (state is CreateRoomLoadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm phòng thành công')));
          context.pop();
        } else if (state is CreateRoomLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.failure.message ?? 'Thêm phòng thất bại')));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.gray25,
        appBar: AppBar(
          backgroundColor: AppColors.white, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.slate700), onPressed: () => context.pop()),
          titleSpacing: 0,
          title: const Padding(
            padding: EdgeInsets.only(right: 40),
            child: Text("Thêm phòng mới", textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.slate900, fontFamily: "Public Sans", fontWeight: FontWeight.w700, fontSize: 18)),
          ),
          bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: AppColors.slate200, height: 1)),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: AppColors.slate100),
                    boxShadow: [BoxShadow(color: AppColors.black.withAlpha(13), blurRadius: 2, offset: const Offset(0, 1))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Số phòng / Tên phòng"),
                      _field(_titleCtrl, "VD: 101"),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label("Diện tích (m²)"), _field(_areaCtrl, "25", suffix: "m²", keyboardType: TextInputType.number)])),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label("Giá thuê"), _field(_rentCtrl, "3.500.000", suffix: "đ", keyboardType: TextInputType.number)])),
                      ]),
                      const SizedBox(height: 16),
                      _label("Tiền đặt cọc"),
                      _field(_depositCtrl, "1.000.000", suffix: "đ", keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.slate100, thickness: 1),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label("Giá điện"), _field(_elecCtrl, "3.500", suffix: "đ/kWh", keyboardType: TextInputType.number)])),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label("Giá nước"), _field(_waterCtrl, "15.000", suffix: "đ/m3", keyboardType: TextInputType.number)])),
                      ]),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.slate100, thickness: 1),
                      const SizedBox(height: 16),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text("Có nội thất", style: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.slate700)),
                        StatefulBuilder(builder: (ctx, setSt) => Switch(
                          value: _hasFurniture,
                          onChanged: (v) { setSt(() => _hasFurniture = v); setState(() {}); },
                          activeColor: AppColors.blue700,
                        )),
                      ]),
                      const SizedBox(height: 16),
                      _label("Mô tả (tùy chọn)"),
                      _field(_descCtrl, "Mô tả thêm về phòng...", maxLines: 3),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<CreateRoomBloc, CreateRoomState>(
              builder: (context, state) {
                final loading = state is CreateRoomLoadInProgress;
                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.slate200))),
                  child: SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton.icon(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2)) : const Icon(Icons.add, color: AppColors.white, size: 16),
                      label: const Text("Thêm phòng", style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w500, fontSize: 16, color: AppColors.white)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
