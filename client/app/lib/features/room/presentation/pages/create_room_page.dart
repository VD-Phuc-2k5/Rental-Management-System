import 'dart:convert';
import 'dart:typed_data';

import 'package:core/constants.dart';
import 'package:domain/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/di.dart';
import '../../../auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../blocs/create_room/create_room_bloc.dart';
import '../widgets/room_amenity_selector.dart';

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
  final _bicycleCtrl = TextEditingController(text: '50000');
  final _motorbikeCtrl = TextEditingController(text: '150000');
  final _carCtrl = TextEditingController(text: '1000000');
  Set<String> _includedCodes = {};
  Map<String, double> _addonPrices = {};
  final List<({XFile file, Uint8List bytes})> _pickedImages = [];
  bool _uploading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _areaCtrl.dispose();
    _rentCtrl.dispose();
    _depositCtrl.dispose();
    _elecCtrl.dispose();
    _waterCtrl.dispose();
    _descCtrl.dispose();
    _bicycleCtrl.dispose();
    _motorbikeCtrl.dispose();
    _carCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      final entries = await Future.wait(
        files.map((f) async => (file: f, bytes: await f.readAsBytes())),
      );
      setState(() => _pickedImages.addAll(entries));
    }
  }

  Future<List<({String url, int sortOrder})>> _uploadImages(String token) async {
    final results = <({String url, int sortOrder})>[];
    for (var i = 0; i < _pickedImages.length; i++) {
      final entry = _pickedImages[i];
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/image?bucket=room-images'),
      )
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(http.MultipartFile.fromBytes('file', entry.bytes, filename: entry.file.name));
      final streamed = await request.send();
      final body = jsonDecode(await streamed.stream.bytesToString()) as Map<String, dynamic>;
      if (streamed.statusCode == 201) {
        results.add((url: (body['data'] as Map<String, dynamic>)['url'] as String, sortOrder: i));
      }
    }
    return results;
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    final area = double.tryParse(_areaCtrl.text.trim());
    final rent = double.tryParse(_rentCtrl.text.trim().replaceAll('.', ''));
    final deposit = double.tryParse(_depositCtrl.text.trim().replaceAll('.', ''));
    final elec = double.tryParse(_elecCtrl.text.trim().replaceAll('.', ''));
    final water = double.tryParse(_waterCtrl.text.trim().replaceAll('.', ''));

    if (title.isEmpty || area == null || rent == null || deposit == null || elec == null || water == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ và đúng định dạng số')),
      );
      return;
    }

    final bicycle = double.tryParse(_bicycleCtrl.text.trim().replaceAll('.', '')) ?? 50000;
    final motorbike = double.tryParse(_motorbikeCtrl.text.trim().replaceAll('.', '')) ?? 150000;
    final car = double.tryParse(_carCtrl.text.trim().replaceAll('.', '')) ?? 1000000;

    List<({String url, int sortOrder})>? uploadedImages;
    if (_pickedImages.isNotEmpty) {
      setState(() => _uploading = true);
      try {
        final token = context.read<AuthenticationBloc>().state.user?.token ?? '';
        uploadedImages = await _uploadImages(token);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lỗi khi tải ảnh lên')),
          );
          setState(() => _uploading = false);
        }
        return;
      }
      if (mounted) setState(() => _uploading = false);
    }

    if (!mounted) return;
    context.read<CreateRoomBloc>().add(
      CreateRoomSubmitted(
        propertyId: widget.propertyId,
        title: title,
        areaSqm: area,
        monthlyRent: rent,
        depositAmount: deposit,
        electricityRatePerKwh: elec,
        waterRatePerM3: water,
        includedAmenityCodes: _includedCodes.toList(),
        addonAmenities: addonPricesToList(_addonPrices),
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        images: uploadedImages,
        parkingFees: RoomParkingFees(bicycle: bicycle, motorbike: motorbike, car: car),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.slate700),
    ),
  );

  Widget _field(
    TextEditingController ctrl,
    String hint, {
    String? suffix,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) =>
      TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.slate900),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: AppColors.slate50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixText: suffix,
          suffixStyle: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.slate400),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.slate200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blue700)),
        ),
      );

  Widget _imagePickerSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label("Ảnh phòng"),
      SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ..._pickedImages.asMap().entries.map(
              (e) => Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(image: MemoryImage(e.value.bytes), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => setState(() => _pickedImages.removeAt(e.key)),
                      child: Container(
                        decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 16, color: AppColors.slate700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.slate200),
                  color: AppColors.slate50,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, color: AppColors.slate400, size: 28),
                    SizedBox(height: 4),
                    Text("Thêm ảnh", style: TextStyle(fontFamily: "Nunito", fontSize: 11, color: AppColors.slate400)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _parkingFeesSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label("Phí gửi xe (đ/tháng/xe)"),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Xe đạp", style: TextStyle(fontFamily: "Nunito", fontSize: 12, color: AppColors.slate500)),
                const SizedBox(height: 4),
                _field(_bicycleCtrl, "50000", suffix: "đ", keyboardType: TextInputType.number),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Xe máy", style: TextStyle(fontFamily: "Nunito", fontSize: 12, color: AppColors.slate500)),
                const SizedBox(height: 4),
                _field(_motorbikeCtrl, "150000", suffix: "đ", keyboardType: TextInputType.number),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ô tô", style: TextStyle(fontFamily: "Nunito", fontSize: 12, color: AppColors.slate500)),
                const SizedBox(height: 4),
                _field(_carCtrl, "1000000", suffix: "đ", keyboardType: TextInputType.number),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRoomBloc, CreateRoomState>(
      listener: (context, state) {
        if (state is CreateRoomLoadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm phòng thành công')));
          context.pop();
        } else if (state is CreateRoomLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.gray25,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.slate700), onPressed: () => context.pop()),
          titleSpacing: 0,
          title: const Padding(
            padding: EdgeInsets.only(right: 40),
            child: Text(
              "Thêm phòng mới",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.slate900, fontFamily: "Public Sans", fontWeight: FontWeight.w700, fontSize: 18),
            ),
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
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.slate100),
                    boxShadow: [BoxShadow(color: AppColors.black.withAlpha(13), blurRadius: 2, offset: const Offset(0, 1))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _imagePickerSection(),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.slate100, thickness: 1),
                      const SizedBox(height: 16),
                      _label("Số phòng / Tên phòng"),
                      _field(_titleCtrl, "VD: 101"),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label("Diện tích (m²)"),
                                _field(_areaCtrl, "25", suffix: "m²", keyboardType: TextInputType.number),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label("Giá thuê"),
                                _field(_rentCtrl, "3.500.000", suffix: "đ", keyboardType: TextInputType.number),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _label("Tiền đặt cọc"),
                      _field(_depositCtrl, "1.000.000", suffix: "đ", keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.slate100, thickness: 1),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label("Giá điện"),
                                _field(_elecCtrl, "3.500", suffix: "đ/kWh", keyboardType: TextInputType.number),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label("Giá nước"),
                                _field(_waterCtrl, "15.000", suffix: "đ/m3", keyboardType: TextInputType.number),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.slate100, thickness: 1),
                      const SizedBox(height: 16),
                      _parkingFeesSection(),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.slate100, thickness: 1),
                      const SizedBox(height: 16),
                      RoomAmenitySelector(
                        includedCodes: _includedCodes,
                        addonPrices: _addonPrices,
                        onIncludedChanged: (v) => setState(() => _includedCodes = v),
                        onAddonChanged: (v) => setState(() => _addonPrices = v),
                      ),
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
                final loading = state is CreateRoomLoadInProgress || _uploading;
                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    border: Border(top: BorderSide(color: AppColors.slate200)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      icon: loading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                          : const Icon(Icons.add, color: AppColors.white, size: 16),
                      label: Text(
                        _uploading ? "Đang tải ảnh..." : "Thêm phòng",
                        style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w500, fontSize: 16, color: AppColors.white),
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