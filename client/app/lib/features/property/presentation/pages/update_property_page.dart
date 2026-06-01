import 'package:core/constants.dart';
import 'package:domain/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/di.dart';
import '../blocs/update_property/update_property_bloc.dart';

const _amenities = [
  ('WIFI', Icons.wifi, 'Wifi'),
  ('PARKING', Icons.local_parking, 'Giữ xe'),
  ('SECURITY', Icons.security, 'An ninh 24/7'),
  ('CAMERA', Icons.videocam_outlined, 'Camera'),
  ('FREE_TIME', Icons.access_time, 'Giờ giấc tự do'),
  ('ELEVATOR', Icons.elevator_outlined, 'Thang máy'),
];

class UpdatePropertyPage extends StatelessWidget {
  const UpdatePropertyPage({super.key, required this.property});
  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UpdatePropertyBloc>(),
      child: _UpdatePropertyView(property: property),
    );
  }
}

class _UpdatePropertyView extends StatefulWidget {
  const _UpdatePropertyView({required this.property});
  final PropertyEntity property;
  @override
  State<_UpdatePropertyView> createState() => _UpdatePropertyViewState();
}

class _UpdatePropertyViewState extends State<_UpdatePropertyView> {
  late final _nameCtrl = TextEditingController(text: widget.property.name);
  late final _addressCtrl = TextEditingController(
    text: widget.property.address,
  );
  late final _wardCtrl = TextEditingController(text: widget.property.ward);
  late final _districtCtrl = TextEditingController(
    text: widget.property.district,
  );
  late final _cityCtrl = TextEditingController(text: widget.property.city);
  late final _descCtrl = TextEditingController(
    text: widget.property.description,
  );
  late final Set<String> _selected = Set.from(widget.property.amenityCodes);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _wardCtrl.dispose();
    _districtCtrl.dispose();
    _cityCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Public Sans',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.slate700,
      ),
    ),
  );

  Widget _field(TextEditingController ctrl, String hint, {int maxLines = 1}) =>
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 16),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.slate300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.blue700),
          ),
        ),
      );

  void _submit() {
    context.read<UpdatePropertyBloc>().add(
      UpdatePropertySubmitted(
        id: widget.property.id,
        name: _nameCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        ward: _wardCtrl.text.trim(),
        district: _districtCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        amenityCodes: _selected.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdatePropertyBloc, UpdatePropertyState>(
      listener: (context, state) {
        if (state is UpdatePropertyLoadSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Cập nhật thành công')));
          context.pop();
        } else if (state is UpdatePropertyLoadFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Cập nhật thất bại')));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.gray25,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.slate700),
            onPressed: () => context.pop(),
          ),
          titleSpacing: 0,
          title: const Padding(
            padding: EdgeInsets.only(right: 40),
            child: Text(
              "Cập nhật nhà trọ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.slate900,
                fontFamily: "Public Sans",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.slate200, height: 1),
          ),
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
                          const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.blue700,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Thông tin cơ bản",
                                style: TextStyle(
                                  fontFamily: "Public Sans",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppColors.blue700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _label("Tên nhà trọ"),
                          _field(_nameCtrl, "VD: Landmark A"),
                          const SizedBox(height: 16),
                          _label("Số nhà, tên đường"),
                          _field(_addressCtrl, "VD: 12 Nguyễn Trãi"),
                          const SizedBox(height: 16),
                          _label("Phường/Xã"),
                          _field(_wardCtrl, "VD: Phường 5"),
                          const SizedBox(height: 16),
                          _label("Quận/Huyện"),
                          _field(_districtCtrl, "VD: Quận 3"),
                          const SizedBox(height: 16),
                          _label("Thành phố"),
                          _field(_cityCtrl, "VD: TP Hồ Chí Minh"),
                          const SizedBox(height: 16),
                          _label("Mô tả"),
                          _field(_descCtrl, "Mô tả thêm...", maxLines: 3),
                        ],
                      ),
                    ),
                    Container(height: 8, color: AppColors.slate100),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.grid_view,
                                color: AppColors.blue700,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Tiện ích chung",
                                style: TextStyle(
                                  fontFamily: "Public Sans",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppColors.blue700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          StatefulBuilder(
                            builder: (ctx, setSt) => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _amenities.map((a) {
                                final code = a.$1;
                                final icon = a.$2;
                                final label = a.$3;
                                final active = _selected.contains(code);
                                return GestureDetector(
                                  onTap: () {
                                    setSt(() {
                                      active
                                          ? _selected.remove(code)
                                          : _selected.add(code);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: active
                                          ? AppColors.blue700.withAlpha(26)
                                          : AppColors.white,
                                      borderRadius: BorderRadius.circular(9999),
                                      border: Border.all(
                                        color: active
                                            ? AppColors.blue700
                                            : AppColors.slate300,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          icon,
                                          size: 14,
                                          color: active
                                              ? AppColors.blue700
                                              : AppColors.slate600,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          label,
                                          style: TextStyle(
                                            fontFamily: "Public Sans",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: active
                                                ? AppColors.blue700
                                                : AppColors.slate600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<UpdatePropertyBloc, UpdatePropertyState>(
              builder: (context, state) {
                final loading = state is UpdatePropertyLoadInProgress;
                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    border: Border(top: BorderSide(color: AppColors.slate200)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(
                              color: AppColors.white,
                            )
                          : const Text(
                              "Lưu thay đổi",
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
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
