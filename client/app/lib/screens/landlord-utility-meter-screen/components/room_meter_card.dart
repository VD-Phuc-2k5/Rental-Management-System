import 'package:app/core/constants.dart';
import 'package:app/screens/landlord-utility-meter-screen/components/utility_meter_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomMeterCard extends StatelessWidget {
  final RoomMeterData room;

  final TextEditingController electricityController;
  final TextEditingController waterController;

  final ValueChanged<int>? onElectricityNewReadingChanged;
  final ValueChanged<int>? onWaterNewReadingChanged;

  const RoomMeterCard({
    super.key,
    required this.room,
    required this.electricityController,
    required this.waterController,
    this.onElectricityNewReadingChanged,
    this.onWaterNewReadingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildElectricitySection(),
          const SizedBox(height: 16),
          _buildWaterSection(),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    final isRented = room.status == RoomStatus.rented;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.blue700.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.apartment, color: AppColors.blue700),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room.hostelName, style: const TextStyle(fontSize: 12)),
              Text(
                room.roomNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isRented ? AppColors.green100 : AppColors.slate100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isRented
              ? Text(
                  "Đang thuê",
                  style: TextStyle(
                    color: AppColors.green700,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                )
              : Text(
                  "Trống",
                  style: TextStyle(
                    color: AppColors.slate500,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
        ),
      ],
    );
  }

  // ================= ELECTRIC =================

  Widget _buildElectricitySection() {
    return _buildMeterSection(
      title: "ĐIỆN (KWH)",
      icon: Icons.bolt,
      iconColor: AppColors.yellow600,
      oldReading: room.electricity.oldReading,
      controller: electricityController,
      editable: room.status == RoomStatus.rented,
      onChanged: onElectricityNewReadingChanged,
    );
  }

  // ================= WATER =================

  Widget _buildWaterSection() {
    return _buildMeterSection(
      title: "NƯỚC (M³)",
      icon: Icons.water_drop_outlined,
      iconColor: AppColors.blue500,
      oldReading: room.water.oldReading,
      controller: waterController,
      editable: room.status == RoomStatus.rented,
      onChanged: onWaterNewReadingChanged,
    );
  }

  // ================= SHARED UI =================

  Widget _buildMeterSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required int oldReading,
    required TextEditingController controller,
    required bool editable,
    ValueChanged<int>? onChanged,
  }) {
    final value = int.tryParse(controller.text) ?? 0;
    final hasError = value > 0 && value <= oldReading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(child: _readonlyField("Chỉ số cũ", oldReading)),
            const SizedBox(width: 12),
            Expanded(
              child: _editableField(
                "Chỉ số mới",
                controller,
                editable,
                hasError,
                onChanged,
              ),
            ),
          ],
        ),

        if (hasError)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              "Chỉ số mới phải lớn hơn chỉ số cũ",
              style: TextStyle(color: AppColors.red500, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _readonlyField(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.slate50,
            border: Border.all(width: 1.0, color: AppColors.slate100),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value.toString()),
        ),
      ],
    );
  }

  Widget _editableField(
    String label,
    TextEditingController controller,
    bool editable,
    bool hasError,
    ValueChanged<int>? onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: editable,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? AppColors.red500 : AppColors.slate300,
              ),
            ),
          ),
          onChanged: (val) {
            final v = int.tryParse(val);
            if (v != null) onChanged?.call(v);
          },
        ),
      ],
    );
  }
}
