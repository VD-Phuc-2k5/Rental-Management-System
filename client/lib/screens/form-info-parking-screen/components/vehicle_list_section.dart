import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
enum VehicleType { motorbike, bicycle, car }

class VehicleFees {
  static int feeOf(VehicleType type) {
    switch (type) {
      case VehicleType.bicycle:
        return 50000;
      case VehicleType.motorbike:
        return 150000;
      case VehicleType.car:
        return 1000000;
    }
  }

  static String labelOf(VehicleType type) {
    switch (type) {
      case VehicleType.bicycle:
        return 'Xe đạp';
      case VehicleType.motorbike:
        return 'Xe máy';
      case VehicleType.car:
        return 'Ô tô';
    }
  }

  static IconData iconOf(VehicleType type) {
    switch (type) {
      case VehicleType.bicycle:
        return Icons.pedal_bike;
      case VehicleType.motorbike:
        return Icons.two_wheeler;
      case VehicleType.car:
        return Icons.directions_car;
    }
  }
}

class VehicleItem {
  final VehicleType type;
  final String plate;
  final int quantity;

  const VehicleItem({
    required this.type,
    required this.plate,
    this.quantity = 1,
  });
}

class VehicleListSection extends StatelessWidget {
  final List<VehicleItem> vehicles;
  final void Function(int index) onDelete;

  const VehicleListSection({
    super.key,
    required this.vehicles,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Title(text: 'DANH SÁCH XE ĐÃ THÊM'),
        const SizedBox(height: 10),

        if (vehicles.isEmpty)
          const Text('Chưa có xe nào', style: TextStyle(color: Color(0xFF647487)))
        else
          ...List.generate(vehicles.length, (i) {
            final v = vehicles[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _VehicleCard(
                type: v.type,
                plate: v.plate,
                quantity: v.quantity,
                onDelete: () => onDelete(i),
              ),
            );
          }),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.slate500,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleType type;
  final String plate;
  final int quantity;
  final VoidCallback onDelete;

  const _VehicleCard({
    required this.type,
    required this.plate,
    required this.quantity,
    required this.onDelete,
  });

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
              child: Icon(VehicleFees.iconOf(type), color: const Color(0xFF195AA4)),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    VehicleFees.labelOf(type),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16,color: AppColors.blue900),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    plate,
                    style: const TextStyle(color: AppColors.slate500,fontWeight: FontWeight.w400),
                  ),
                  if (quantity > 1) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Số lượng: $quantity',
                      style: const TextStyle(color: Color(0xFF647487)),
                    ),
                  ],
                ],
              ),
            ),

            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: AppColors.red500),
            ),
          ],
        ),
      ),
    );
  }
}