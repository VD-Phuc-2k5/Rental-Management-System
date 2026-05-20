import 'package:app/core/constants.dart';
import 'package:app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/create_property/create_property_bloc.dart';

const _amenities = [
  ('WIFI', Icons.wifi, 'Wifi'),
  ('PARKING', Icons.local_parking, 'Giữ xe'),
  ('SECURITY', Icons.security, 'An ninh 24/7'),
  ('CAMERA', Icons.videocam_outlined, 'Camera'),
  ('FREE_TIME', Icons.access_time, 'Giờ giấc tự do'),
  ('ELEVATOR', Icons.elevator_outlined, 'Thang máy'),
];

class CreatePropertyPage extends StatelessWidget {
  const CreatePropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreatePropertyBloc>(),
      child: const _CreatePropertyView(),
    );
  }
}

class _CreatePropertyView extends StatefulWidget {
  const _CreatePropertyView();
  @override
  State<_CreatePropertyView> createState() => _CreatePropertyViewState();
}

class _CreatePropertyViewState extends State<_CreatePropertyView> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _wardCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final Set<String> _selected = {};

  @override
  void dispose() {
    _nameCtrl.dispose(); _addressCtrl.dispose(); _wardCtrl.dispose();
    _districtCtrl.dispose(); _cityCtrl.dispose(); _descCtrl.dispose();
    super.dispose();
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontFamily: 'Public Sans', fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.slate700)),
  );

  Widget _field(TextEditingController ctrl, String hint, {int maxLines = 1}) => TextField(
    controller: ctrl,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 16),
      filled: true, fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.slate300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blue700)),
    ),
  );

  void _submit() {
    final name = _nameCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final ward = _wardCtrl.text.trim();
    final district = _districtCtrl.text.trim();
    final city = _cityCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    if (name.isEmpty || address.isEmpty || ward.isEmpty || district.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')));
      return;
    }
    context.read<CreatePropertyBloc>().add(CreatePropertySubmitted(
      name: name, address: address, ward: ward, district: district,
      city: city, description: desc, amenityCodes: _selected.toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePropertyBloc, CreatePropertyState>(
      listener: (context, state) {
        if (state is CreatePropertyLoadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm nhà trọ thành công')));
          context.pop();
        } else if (state is CreatePropertyLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.failure.message ?? 'Thêm thất bại')));
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
            child: Text("Thêm nhà trọ mới", textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.slate900, fontFamily: "Public Sans", fontWeight: FontWeight.w700, fontSize: 18)),
          ),
          bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: AppColors.slate200, height: 1)),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: const [Icon(Icons.info_outline, color: AppColors.blue700, size: 16), SizedBox(width: 8),
                            Text("Thông tin cơ bản", style: TextStyle(fontFamily: "Public Sans", fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.blue700))]),
                          const SizedBox(height: 16),
                          _label("Tên nhà trọ"), _field(_nameCtrl, "VD: Landmark A"),
                          const SizedBox(height: 16),
                          _label("Số nhà, tên đường"), _field(_addressCtrl, "VD: 12 Nguyễn Trãi"),
                          const SizedBox(height: 16),
                          _label("Phường/Xã"), _field(_wardCtrl, "VD: Phường 5"),
                          const SizedBox(height: 16),
                          _label("Quận/Huyện"), _field(_districtCtrl, "VD: Quận 3"),
                          const SizedBox(height: 16),
                          _label("Thành phố"), _field(_cityCtrl, "VD: TP Hồ Chí Minh"),
                          const SizedBox(height: 16),
                          _label("Mô tả"), _field(_descCtrl, "Mô tả thêm về khu trọ...", maxLines: 3),
                        ],
                      ),
                    ),
                    Container(height: 8, color: AppColors.slate100),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: const [Icon(Icons.grid_view, color: AppColors.blue700, size: 16), SizedBox(width: 8),
                            Text("Tiện ích chung", style: TextStyle(fontFamily: "Public Sans", fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.blue700))]),
                          const SizedBox(height: 16),
                          StatefulBuilder(builder: (ctx, setSt) => Wrap(
                            spacing: 8, runSpacing: 8,
                            children: _amenities.map((a) {
                              final code = a.$1; final icon = a.$2; final label = a.$3;
                              final active = _selected.contains(code);
                              return GestureDetector(
                                onTap: () { setSt(() { active ? _selected.remove(code) : _selected.add(code); }); },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: active ? AppColors.blue700.withAlpha(26) : AppColors.white,
                                    borderRadius: BorderRadius.circular(9999),
                                    border: Border.all(color: active ? AppColors.blue700 : AppColors.slate300),
                                  ),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    Icon(icon, size: 14, color: active ? AppColors.blue700 : AppColors.slate600),
                                    const SizedBox(width: 6),
                                    Text(label, style: TextStyle(fontFamily: "Public Sans", fontWeight: FontWeight.w500, fontSize: 14, color: active ? AppColors.blue700 : AppColors.slate600)),
                                  ]),
                                ),
                              );
                            }).toList(),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<CreatePropertyBloc, CreatePropertyState>(
              builder: (context, state) {
                final loading = state is CreatePropertyLoadInProgress;
                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.slate200))),
                  child: SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      child: loading ? const CircularProgressIndicator(color: AppColors.white) : const Text("Thêm nhà trọ", style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.white)),
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
