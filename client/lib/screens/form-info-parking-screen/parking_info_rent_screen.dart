import 'package:flutter/material.dart';

import 'package:app/screens/form-info-parking-screen/components/parking_header.dart';
import 'package:app/screens/form-info-parking-screen/components/parking_toggle_section.dart';
import 'package:app/screens/form-info-parking-screen/components/vehicle_list_section.dart';
import 'package:app/screens/form-info-parking-screen/components/vehicle_form_section.dart';
import 'package:app/screens/form-info-parking-screen/components/parking_bottom_bar.dart';
import 'package:app/screens/form-info-agreement-services-screen/agreement_screen.dart';
class ParkingInfoScreen extends StatefulWidget {
  const ParkingInfoScreen({super.key});

  @override
  State<ParkingInfoScreen> createState() => _ParkingInfoScreenState();
}

class _ParkingInfoScreenState extends State<ParkingInfoScreen> {
  bool hasParking = true;

  final plateCtl = TextEditingController();

  VehicleType selectedType = VehicleType.motorbike;
  int quantity = 1;

  final List<VehicleItem> vehicles = [
    const VehicleItem(type: VehicleType.motorbike, plate: '59A-123.45', quantity: 1),
  ];

  @override
  void dispose() {
    plateCtl.dispose();
    super.dispose();
  }

  int get _unitFee => VehicleFees.feeOf(selectedType);

  int get _totalFee => _unitFee * quantity;

  void _addVehicle() {
    final plate = plateCtl.text.trim();

    if (plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập biển số xe')),
      );
      return;
    }

    setState(() {
      vehicles.add(VehicleItem(type: selectedType, plate: plate, quantity: quantity));
      // reset form
      plateCtl.clear();
      selectedType = VehicleType.motorbike;
      quantity = 1;
    });
  }

  void _deleteVehicle(int index) {
    setState(() {
      vehicles.removeAt(index);
    });
  }

  void _goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AgreementUiScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông tin gửi xe',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ParkingHeader(step: 2, total: 3),
            const SizedBox(height: 14),

            ParkingToggleSection(
              value: hasParking,
              onChanged: (v) => setState(() => hasParking = v),
            ),

            if (hasParking) ...[
              const SizedBox(height: 16),

              VehicleListSection(
                vehicles: vehicles,
                onDelete: _deleteVehicle,
              ),

              const SizedBox(height: 16),

              VehicleFormSection(
                selectedType: selectedType,
                onTypeChanged: (t) => setState(() => selectedType = t),
                plateCtl: plateCtl,
                quantity: quantity,
                onQuantityChanged: (q) => setState(() => quantity = q),
                totalFee: _totalFee,
                onAddVehicle: _addVehicle,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: ParkingBottomBar(
        onNext: () => _goNext(context),
      ),
    );
  }
}