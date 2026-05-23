import 'dart:convert';

import 'package:core/constants.dart' hide AppColors;
import 'package:domain/rental_request.dart';
import 'package:domain/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../blocs/create_rental_request/create_rental_request_bloc.dart';

// ── Vehicle type ──────────────────────────────────────────────────────────────

enum _VehicleType { bicycle, motorbike, car }

extension _VehicleTypeX on _VehicleType {
  String get label => switch (this) {
    _VehicleType.bicycle => 'Xe đạp',
    _VehicleType.motorbike => 'Xe máy',
    _VehicleType.car => 'Ô tô',
  };

  IconData get icon => switch (this) {
    _VehicleType.bicycle => Icons.pedal_bike,
    _VehicleType.motorbike => Icons.two_wheeler,
    _VehicleType.car => Icons.directions_car,
  };

  double feeFrom(RoomParkingFees? fees) => switch (this) {
    _VehicleType.bicycle => fees?.bicycle ?? 50000,
    _VehicleType.motorbike => fees?.motorbike ?? 150000,
    _VehicleType.car => fees?.car ?? 1000000,
  };
}

// ── Page ──────────────────────────────────────────────────────────────────────

class RentalRequestWizardPage extends StatelessWidget {
  const RentalRequestWizardPage({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateRentalRequestBloc>(),
      child: _WizardView(roomId: roomId),
    );
  }
}

class _WizardView extends StatefulWidget {
  const _WizardView({required this.roomId});

  final String roomId;

  @override
  State<_WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<_WizardView> {
  int _step = 0;
  final List<_MemberForm> _members = [_MemberForm(isRoomLeader: true)];
  bool _hasParking = false;
  final List<_VehicleForm> _vehicles = [];
  final _noteCtl = TextEditingController();
  RoomEntity? _room;

  @override
  void initState() {
    super.initState();
    _fetchRoom();
  }

  Future<void> _fetchRoom() async {
    final result = await getIt<GetRoomByIdUsecase>()(
      GetRoomByIdParams(id: widget.roomId),
    );
    result.fold((_) {}, (room) {
      if (mounted) setState(() => _room = room);
    });
  }

  @override
  void dispose() {
    _noteCtl.dispose();
    for (final m in _members) {
      m.dispose();
    }
    for (final v in _vehicles) {
      v.dispose();
    }
    super.dispose();
  }

  List<MemberInfo> get _memberInfoList => _members
      .map(
        (m) => MemberInfo(
          fullName: m.nameCtl.text.trim(),
          isRoomLeader: m.isRoomLeader,
          phone: m.phoneCtl.text.trim().isEmpty ? null : m.phoneCtl.text.trim(),
          identityNumber: m.cccdCtl.text.trim().isEmpty
              ? null
              : m.cccdCtl.text.trim(),
          identityImageUrl: m.identityImageUrl,
          email: m.emailCtl.text.trim().isEmpty ? null : m.emailCtl.text.trim(),
          address: m.addressCtl.text.trim().isEmpty
              ? null
              : m.addressCtl.text.trim(),
          dateOfBirth: m.dobCtl.text.trim().isEmpty
              ? null
              : m.dobCtl.text.trim(),
        ),
      )
      .toList();

  List<VehicleInfo> get _vehicleInfoList => _vehicles
      .map(
        (v) => VehicleInfo(
          type: v.type.label,
          plate: v.plateCtl.text.trim(),
          quantity: v.quantity,
        ),
      )
      .toList();

  bool get _step0Valid =>
      _members.isNotEmpty &&
      _members.any((m) => m.isRoomLeader) &&
      _members.every((m) => m.nameCtl.text.trim().isNotEmpty);

  bool get _step1Valid =>
      !_hasParking || _vehicles.every((v) => v.plateCtl.text.trim().isNotEmpty);

  void _next() {
    if (_step == 0 && !_step0Valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập họ tên đầy đủ và chọn trưởng phòng'),
        ),
      );
      return;
    }
    if (_step == 1 && !_step1Valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập biển số xe đầy đủ')),
      );
      return;
    }
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _submit() {
    final note = _noteCtl.text.trim();
    context.read<CreateRentalRequestBloc>().add(
      CreateRentalRequestSubmitted(
        roomId: widget.roomId,
        note: note.isEmpty ? null : note,
        memberInfo: _memberInfoList,
        parkingInfo: _hasParking ? _vehicleInfoList : [],
      ),
    );
  }

  String get _stepTitle => switch (_step) {
    0 => 'Thông tin khách thuê',
    1 => 'Thông tin gửi xe',
    _ => 'Ghi chú & Xác nhận',
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRentalRequestBloc, CreateRentalRequestState>(
      listener: (context, state) {
        if (state is CreateRentalRequestLoadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gửi yêu cầu thuê thành công!')),
          );
          context.pop();
        } else if (state is CreateRentalRequestLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure.toString())),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_step > 0) {
                setState(() => _step--);
              } else {
                context.pop();
              }
            },
          ),
          title: Text(
            _stepTitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: IndexedStack(
          index: _step,
          children: [
            _MembersStep(
              members: _members,
              onChanged: () => setState(() {}),
            ),
            _ParkingStep(
              hasParking: _hasParking,
              onHasParkingChanged: (v) => setState(() => _hasParking = v),
              vehicles: _vehicles,
              parkingFees: _room?.parkingFees,
              onChanged: () => setState(() {}),
            ),
            _NoteStep(noteCtl: _noteCtl, room: _room),
          ],
        ),
        bottomNavigationBar:
            BlocBuilder<CreateRentalRequestBloc, CreateRentalRequestState>(
              builder: (context, state) {
                final isLoading = state is CreateRentalRequestLoadInProgress;
                return _BottomBar(
                  label: _step < 2 ? 'Tiếp theo' : 'Gửi yêu cầu thuê',
                  isLoading: isLoading,
                  onTap: isLoading ? null : _next,
                );
              },
            ),
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.label,
    required this.isLoading,
    this.onTap,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFDCE0E5))),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onTap,
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.blue700),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Step header (3-segment step bar) ─────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step, required this.sectionTitle});

  final int step;
  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bước $step/3',
          style: const TextStyle(
            color: Color(0xFF195AA4),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (i) {
            final done = (i + 1) <= step;
            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(right: i == 2 ? 0 : 8),
                decoration: BoxDecoration(
                  color: done
                      ? const Color(0xFF195AA4)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),
        Text(
          sectionTitle,
          style: const TextStyle(
            color: Color(0xFF195AA4),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }
}

// ── Labeled field (label above, white fill, gray border) ──────────────────────

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.hint = '',
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final String hint;
  final bool readOnly;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Color(0xFF111417),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            children: [
              TextSpan(text: label),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF647487),
              fontSize: 16,
            ),
            suffixIcon: suffixIcon == null
                ? null
                : Icon(suffixIcon, color: const Color(0xFF647487)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFDCE0E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF195AA4)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Step 0: Members ───────────────────────────────────────────────────────────

class _MembersStep extends StatelessWidget {
  const _MembersStep({required this.members, required this.onChanged});

  final List<_MemberForm> members;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      children: [
        const _StepHeader(step: 1, sectionTitle: 'THÔNG TIN THÀNH VIÊN'),
        const SizedBox(height: 14),
        ...members.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _MemberCard(
              index: entry.key,
              form: entry.value,
              canRemove: members.length > 1 && !entry.value.isRoomLeader,
              onRemove: () {
                members.removeAt(entry.key);
                onChanged();
              },
              onSetLeader: () {
                for (final m in members) {
                  m.isRoomLeader = false;
                }
                entry.value.isRoomLeader = true;
                onChanged();
              },
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
            members.add(_MemberForm());
            onChanged();
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 52,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF195AA4), width: 1.4),
              color: Colors.white,
            ),
            child: const Text(
              '+ Thêm thành viên',
              style: TextStyle(
                color: Color(0xFF195AA4),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MemberCard extends StatefulWidget {
  const _MemberCard({
    required this.index,
    required this.form,
    required this.canRemove,
    required this.onRemove,
    required this.onSetLeader,
    required this.onChanged,
  });

  final int index;
  final _MemberForm form;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onSetLeader;
  final VoidCallback onChanged;

  @override
  State<_MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<_MemberCard> {
  bool _picking = false;

  Future<void> _pickAndUploadIdCard() async {
    setState(() => _picking = true);
    try {
      final xfile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (xfile == null || !mounted) return;
      final token = context.read<AuthenticationBloc>().state.user?.token ?? '';
      final request =
          http.MultipartRequest(
              'POST',
              Uri.parse('$baseUrl/upload/image?bucket=identity-images'),
            )
            ..headers['Authorization'] = 'Bearer $token'
            ..files.add(await http.MultipartFile.fromPath('file', xfile.path));
      final response = await request.send();
      if (!mounted) return;
      final body =
          jsonDecode(await response.stream.bytesToString())
              as Map<String, dynamic>;
      final url = (body['data'] as Map<String, dynamic>)['url'] as String?;
      if (url != null) {
        widget.form.identityImageUrl = url;
        widget.onChanged();
        setState(() {});
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tải ảnh căn cước thất bại')),
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final idUrl = widget.form.identityImageUrl;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.form.isRoomLeader
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: widget.form.isRoomLeader
                      ? const Color(0xFF195AA4)
                      : Colors.grey,
                ),
                const SizedBox(width: 10),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF1F5F9),
                  ),
                  child: const Icon(Icons.person_outline, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thành viên ${widget.index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      if (widget.form.isRoomLeader)
                        const Text(
                          'Trưởng phòng',
                          style: TextStyle(
                            color: Color(0xFF195AA4),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: widget.onSetLeader,
                          child: const Text(
                            'Chọn làm trưởng phòng',
                            style: TextStyle(
                              color: Color(0xCC195AA4),
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.canRemove)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Họ và tên',
              isRequired: true,
              hint: 'Nhập họ và tên',
              controller: widget.form.nameCtl,
              onChanged: (_) => widget.onChanged(),
            ),
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Ngày sinh',
              hint: 'dd/mm/yyyy',
              controller: widget.form.dobCtl,
              readOnly: true,
              suffixIcon: Icons.calendar_month_outlined,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  initialDate: DateTime(2000, 1, 1),
                );
                if (picked != null && context.mounted) {
                  widget.form.dobCtl.text =
                      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                }
              },
            ),
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Số CCCD',
              hint: 'Nhập số CCCD',
              controller: widget.form.cccdCtl,
            ),
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Địa chỉ thường trú',
              hint: 'Nhập địa chỉ',
              controller: widget.form.addressCtl,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Số điện thoại',
              hint: 'Nhập số điện thoại',
              controller: widget.form.phoneCtl,
              keyboardType: TextInputType.phone,
              suffixIcon: Icons.call_outlined,
            ),
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Email',
              hint: 'Nhập địa chỉ email',
              controller: widget.form.emailCtl,
              keyboardType: TextInputType.emailAddress,
              suffixIcon: Icons.mail_outline,
            ),
            const SizedBox(height: 12),
            const Text(
              'Ảnh CCCD',
              style: TextStyle(
                color: Color(0xFF111417),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            if (idUrl != null) ...[
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      idUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.form.identityImageUrl = null;
                      widget.onChanged();
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _picking ? null : _pickAndUploadIdCard,
                icon: _picking
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file_outlined),
                label: Text(
                  idUrl == null ? 'Tải lên ảnh CCCD' : 'Thay ảnh CCCD',
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFDCE0E5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 1: Parking ───────────────────────────────────────────────────────────

class _ParkingStep extends StatelessWidget {
  const _ParkingStep({
    required this.hasParking,
    required this.onHasParkingChanged,
    required this.vehicles,
    required this.onChanged,
    this.parkingFees,
  });

  final bool hasParking;
  final ValueChanged<bool> onHasParkingChanged;
  final List<_VehicleForm> vehicles;
  final VoidCallback onChanged;
  final RoomParkingFees? parkingFees;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      children: [
        const _StepHeader(step: 2, sectionTitle: 'THÔNG TIN GỬI XE'),
        const SizedBox(height: 14),
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Khách có gửi xe không?',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.slate800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Bật để thêm thông tin gửi xe của khách',
                        style: TextStyle(color: AppColors.slate500),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: hasParking,
                  onChanged: onHasParkingChanged,
                  activeTrackColor: AppColors.blue700,
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: AppColors.gray200,
                  inactiveThumbColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (hasParking) ...[
          const SizedBox(height: 16),
          if (vehicles.isNotEmpty) ...[
            const Text(
              'DANH SÁCH XE ĐÃ THÊM',
              style: TextStyle(
                color: AppColors.slate500,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),
            ...vehicles.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _VehicleListCard(
                  form: entry.value,
                  onDelete: () {
                    vehicles.removeAt(entry.key);
                    onChanged();
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          _VehicleFormCard(
            parkingFees: parkingFees,
            onAdd: (form) {
              vehicles.add(form);
              onChanged();
            },
          ),
        ],
      ],
    );
  }
}

class _VehicleListCard extends StatelessWidget {
  const _VehicleListCard({required this.form, required this.onDelete});

  final _VehicleForm form;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF1F5F9),
              ),
              child: Icon(form.type.icon, color: const Color(0xFF195AA4)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    form.type.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.blue900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    form.plateCtl.text,
                    style: const TextStyle(color: AppColors.slate500),
                  ),
                  if (form.quantity > 1)
                    Text(
                      'Số lượng: ${form.quantity}',
                      style: const TextStyle(color: Color(0xFF647487)),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.red500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleFormCard extends StatefulWidget {
  const _VehicleFormCard({required this.onAdd, this.parkingFees});

  final ValueChanged<_VehicleForm> onAdd;
  final RoomParkingFees? parkingFees;

  @override
  State<_VehicleFormCard> createState() => _VehicleFormCardState();
}

class _VehicleFormCardState extends State<_VehicleFormCard> {
  _VehicleType _type = _VehicleType.motorbike;
  final _plateCtl = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _plateCtl.dispose();
    super.dispose();
  }

  String _formatMoney(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write('.');
    }
    return buf.toString();
  }

  void _add() {
    final plate = _plateCtl.text.trim();
    if (plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập biển số xe')),
      );
      return;
    }
    final form = _VehicleForm()
      ..type = _type
      ..quantity = _quantity;
    form.plateCtl.text = plate;
    widget.onAdd(form);
    setState(() {
      _plateCtl.clear();
      _type = _VehicleType.motorbike;
      _quantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thêm xe mới',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.blue900,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Loại xe',
              style: TextStyle(
                color: AppColors.blue900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDCE0E5)),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<_VehicleType>(
                  value: _type,
                  isExpanded: true,
                  items: _VehicleType.values
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(
                            t.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.blue900,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _type = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Biển số xe',
              style: TextStyle(
                color: AppColors.blue900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _plateCtl,
              decoration: InputDecoration(
                hintText: 'Ví dụ: 59A-123.45',
                hintStyle: const TextStyle(
                  color: AppColors.slate400,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFDCE0E5)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Số lượng xe',
              style: TextStyle(
                color: AppColors.blue900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _SquareBtn(
                  icon: Icons.remove,
                  onTap: _quantity <= 1
                      ? null
                      : () => setState(() => _quantity--),
                ),
                const SizedBox(width: 18),
                Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.blue900,
                  ),
                ),
                const SizedBox(width: 18),
                _SquareBtn(
                  icon: Icons.add,
                  filled: true,
                  onTap: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Phí gửi xe/tháng',
              style: TextStyle(
                color: AppColors.blue900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDCE0E5)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatMoney(
                        (_type.feeFrom(widget.parkingFees) * _quantity).toInt(),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.blue900,
                      ),
                    ),
                  ),
                  const Text(
                    'VND/tháng',
                    style: TextStyle(
                      color: AppColors.slate500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: TextButton.icon(
                onPressed: _add,
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.blue700,
                ),
                label: const Text(
                  'Thêm xe',
                  style: TextStyle(
                    color: AppColors.blue700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareBtn extends StatelessWidget {
  const _SquareBtn({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: filled ? const Color(0xFF195AA4) : Colors.white,
          border: Border.all(color: const Color(0xFF195AA4)),
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : const Color(0xFF195AA4),
        ),
      ),
    );
  }
}

// ── Step 2: Note & Confirm ────────────────────────────────────────────────────

class _NoteStep extends StatelessWidget {
  const _NoteStep({required this.noteCtl, this.room});

  final TextEditingController noteCtl;
  final RoomEntity? room;

  String _fmt(num v) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write('.');
    }
    return '$buf VND';
  }

  @override
  Widget build(BuildContext context) {
    final r = room;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      children: [
        const _StepHeader(step: 3, sectionTitle: 'GHI CHÚ & XÁC NHẬN'),
        const SizedBox(height: 14),
        if (r != null) ...[
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bảng giá dịch vụ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.blue900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PriceRow(
                    label: 'Tiền thuê/tháng',
                    value: _fmt(r.monthlyRent),
                  ),
                  _PriceRow(
                    label: 'Tiền đặt cọc',
                    value: _fmt(r.depositAmount),
                  ),
                  _PriceRow(
                    label: 'Điện (kWh)',
                    value: _fmt(r.electricityRatePerKwh),
                  ),
                  _PriceRow(label: 'Nước (m³)', value: _fmt(r.waterRatePerM3)),
                  if (r.parkingFees.bicycle > 0)
                    _PriceRow(
                      label: 'Gửi xe đạp/tháng',
                      value: _fmt(r.parkingFees.bicycle),
                    ),
                  if (r.parkingFees.motorbike > 0)
                    _PriceRow(
                      label: 'Gửi xe máy/tháng',
                      value: _fmt(r.parkingFees.motorbike),
                    ),
                  if (r.parkingFees.car > 0)
                    _PriceRow(
                      label: 'Gửi ô tô/tháng',
                      value: _fmt(r.parkingFees.car),
                    ),
                  if (r.addonAmenities.isNotEmpty) ...[
                    const Divider(height: 20),
                    const Text(
                      'Dịch vụ thêm',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.slate500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...r.addonAmenities.map(
                      (a) =>
                          _PriceRow(label: a.code, value: _fmt(a.monthlyPrice)),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ghi chú cho chủ trọ (tuỳ chọn)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111417),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: noteCtl,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Nhập ghi chú...',
                    hintStyle: const TextStyle(color: Color(0xFF647487)),
                    filled: true,
                    fillColor: const Color(0xFFF3F5F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFDCE0E5)),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.blue700.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.blue700.withValues(alpha: 0.15),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.blue700),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sau khi gửi, chủ trọ sẽ xem xét và gửi hợp đồng. '
                  'Trưởng phòng cần ký hợp đồng và chuyển tiền đặt cọc qua MoMo.',
                  style: TextStyle(fontSize: 12, color: AppColors.blue700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.slate600)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.blue900,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Form data holders ─────────────────────────────────────────────────────────

class _MemberForm {
  _MemberForm({this.isRoomLeader = false});

  bool isRoomLeader;
  String? identityImageUrl;
  final nameCtl = TextEditingController();
  final dobCtl = TextEditingController();
  final cccdCtl = TextEditingController();
  final addressCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final emailCtl = TextEditingController();

  void dispose() {
    nameCtl.dispose();
    dobCtl.dispose();
    cccdCtl.dispose();
    addressCtl.dispose();
    phoneCtl.dispose();
    emailCtl.dispose();
  }
}

class _VehicleForm {
  _VehicleType type = _VehicleType.motorbike;
  final plateCtl = TextEditingController();
  int quantity = 1;

  void dispose() => plateCtl.dispose();
}
