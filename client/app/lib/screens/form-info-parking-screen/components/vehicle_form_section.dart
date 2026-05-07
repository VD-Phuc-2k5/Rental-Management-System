import 'package:flutter/material.dart';
import 'vehicle_list_section.dart';
import 'package:app/core/constants.dart';
class VehicleFormSection extends StatelessWidget {
  final VehicleType selectedType;
  final ValueChanged<VehicleType> onTypeChanged;

  final TextEditingController plateCtl;

  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  final int totalFee;
  final VoidCallback onAddVehicle;

  const VehicleFormSection({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.plateCtl,
    required this.quantity,
    required this.onQuantityChanged,
    required this.totalFee,
    required this.onAddVehicle,
  });

  String _money(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write('.');
    }
    return buf.toString();
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
            const Text('Thêm xe mới', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18,color: AppColors.blue900)),
            const SizedBox(height: 12),

            const _FieldLabel('Loại xe'),
            const SizedBox(height: 8),
            _DropdownVehicleType(
              value: selectedType,
              onChanged: onTypeChanged,
            ),

            const SizedBox(height: 12),
            const _FieldLabel('Biển số xe'),
            const SizedBox(height: 8),
            TextField(
              controller: plateCtl,
              decoration: InputDecoration(
                hintText: 'Ví dụ: 59A-123.45',
                hintStyle: const TextStyle(color: AppColors.slate400,fontSize: 16,fontWeight: FontWeight.w400),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFDCE0E5)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),

            const SizedBox(height: 12),
            const _FieldLabel('Số lượng xe'),
            const SizedBox(height: 8),
            _QuantityStepper(
              value: quantity,
              onChanged: onQuantityChanged,
            ),

            const SizedBox(height: 12),
            const _FieldLabel('Phí gửi xe/tháng'),
            const SizedBox(height: 8),
            _FeeBox(value: _money(totalFee)),

            const SizedBox(height: 14),
            Center(
              child: TextButton.icon(
                onPressed: onAddVehicle,
                icon: const Icon(Icons.add_circle_outline, color: AppColors.blue700),
                label: const Text(
                  'Thêm xe khác',
                  style: TextStyle(color: AppColors.blue700, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.blue900,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _DropdownVehicleType extends StatelessWidget {
  final VehicleType value;
  final ValueChanged<VehicleType> onChanged;

  const _DropdownVehicleType({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDCE0E5)),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VehicleType>(
          value: value,
          isExpanded: true,
          items: VehicleType.values.map((t) {
            return DropdownMenuItem(
              value: t,
              child: Text(VehicleFees.labelOf(t),
                style: TextStyle(fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.blue900),),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SquareBtn(
          icon: Icons.remove,
          onTap: value <= 1 ? null : () => onChanged(value - 1),
        ),
        const SizedBox(width: 18),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18,color: AppColors.blue900)),
        const SizedBox(width: 18),
        _SquareBtn(
          icon: Icons.add,
          filled: true,
          onTap: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _SquareBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  const _SquareBtn({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: filled ? const Color(0xFF195AA4) : Colors.white,
          border: Border.all(
            color: const Color(0xFF195AA4),
          ),
        ),
        child: Icon(
          icon,
          color: disabled
              ? const Color(0xFF195AA4)
              : (filled ? Colors.white : const Color(0xFF195AA4)),
        ),
      ),
    );
  }
}

class _FeeBox extends StatelessWidget {
  final String value;
  const _FeeBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              value,
              style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: AppColors.blue900),
            ),
          ),
          const Text(
            'VND/tháng',
            style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}