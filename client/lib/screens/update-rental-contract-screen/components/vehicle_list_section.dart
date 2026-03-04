import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ContractVehicle {
  final String name;
  final String licensePlate;

  const ContractVehicle({required this.name, required this.licensePlate});
}

class VehicleListSection extends StatelessWidget {
  final List<ContractVehicle> vehicles;
  final VoidCallback onAddVehicle;
  final void Function(int index) onDeleteVehicle;

  const VehicleListSection({
    super.key,
    required this.vehicles,
    required this.onAddVehicle,
    required this.onDeleteVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.0, color: AppColors.slate200),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(10),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: AppColors.blue50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.two_wheeler,
                  color: AppColors.blue700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Danh sách xe",
                style: TextStyle(
                  color: AppColors.blue900,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(vehicles.length, (i) {
            final vehicle = vehicles[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _VehicleCard(
                name: vehicle.name,
                licensePlate: vehicle.licensePlate,
                onDelete: () => onDeleteVehicle(i),
              ),
            );
          }),
          const SizedBox(height: 4),
          _AddButton(text: '+ Thêm xe', onPressed: onAddVehicle),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final String name;
  final String licensePlate;
  final VoidCallback onDelete;

  const _VehicleCard({
    required this.name,
    required this.licensePlate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.blue900,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  licensePlate,
                  style: const TextStyle(
                    color: AppColors.slate500,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: AppColors.red500),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _AddButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.blue700, width: 1.5),
          color: Colors.transparent,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.blue700,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
