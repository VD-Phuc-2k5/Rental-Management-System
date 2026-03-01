import 'package:app/core/constants.dart';
import 'package:app/screens/landlord-utility-meter-screens/components/utility_meter_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomMeterCard extends StatelessWidget {
  final RoomMeterData room;
  final ValueChanged<int>? onElectricityNewReadingChanged;
  final ValueChanged<int>? onWaterNewReadingChanged;

  const RoomMeterCard({
    super.key,
    required this.room,
    this.onElectricityNewReadingChanged,
    this.onWaterNewReadingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(width: 1.0, color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          _buildHeader(),
          _buildElectricitySection(),
          _buildWaterSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.blue700.withAlpha(26),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.apartment,
            color: AppColors.blue700,
            size: 24,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                room.hostelName,
                style: const TextStyle(
                  color: AppColors.slate500,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              Text(
                room.roomNumber,
                style: const TextStyle(
                  color: AppColors.blue950,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final isRented = room.status == RoomStatus.rented;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isRented ? AppColors.green500.withAlpha(26) : AppColors.slate200,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        isRented ? "Đang thuê" : "Trống",
        style: TextStyle(
          color: isRented ? AppColors.green700 : AppColors.slate500,
          fontFamily: "Inter",
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildElectricitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        const Row(
          children: [
            Icon(Icons.bolt, color: AppColors.yellow600, size: 16),
            SizedBox(width: 4.0),
            Text(
              "ĐIỆN (KWH)",
              style: TextStyle(
                color: AppColors.slate700,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: _buildReadingField(
                label: "Chỉ số cũ",
                value: room.electricity.oldReading,
                isEditable: false,
              ),
            ),
            const SizedBox(width: 12.0),
            Flexible(
              flex: 1,
              child: _buildReadingField(
                label: "Chỉ số mới",
                value: room.electricity.newReading,
                isEditable: room.status == RoomStatus.rented,
                oldReading: room.electricity.oldReading,
                onChanged: onElectricityNewReadingChanged,
              ),
            ),
          ],
        ),
        if (room.status == RoomStatus.rented &&
            room.electricity.consumption > 0)
          Text(
            "Tiêu thụ: ${room.electricity.consumption} kWh",
            style: const TextStyle(
              color: AppColors.blue700,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildWaterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        const Row(
          children: [
            Icon(Icons.water_drop, color: AppColors.blue500, size: 16),
            SizedBox(width: 4.0),
            Text(
              "NƯỚC (M³)",
              style: TextStyle(
                color: AppColors.slate700,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: _buildReadingField(
                label: "Chỉ số cũ",
                value: room.water.oldReading,
                isEditable: false,
              ),
            ),
            const SizedBox(width: 12.0),
            Flexible(
              flex: 1,
              child: _buildReadingField(
                label: "Chỉ số mới",
                value: room.water.newReading,
                isEditable: room.status == RoomStatus.rented,
                oldReading: room.water.oldReading,
                onChanged: onWaterNewReadingChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadingField({
    required String label,
    required int value,
    required bool isEditable,
    int? oldReading,
    ValueChanged<int>? onChanged,
  }) {
    final hasError = oldReading != null && value > 0 && value <= oldReading;
    final borderColor = hasError
        ? AppColors.red500
        : (isEditable ? AppColors.slate300 : AppColors.slate200);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.0,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.slate500,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isEditable ? AppColors.white : AppColors.slate50,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 1.5, color: borderColor),
          ),
          child: isEditable
              ? TextFormField(
                  initialValue: value.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    color: AppColors.blue950,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    final newValue = int.tryParse(val);
                    if (newValue != null) {
                      onChanged?.call(newValue);
                    }
                  },
                )
              : Text(
                  value.toString(),
                  style: const TextStyle(
                    color: AppColors.slate600,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "Chỉ số mới phải lớn hơn chỉ số cũ",
              style: const TextStyle(
                color: AppColors.red500,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}
