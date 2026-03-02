import 'package:flutter/material.dart';

import 'package:app/screens/form-info-agreement-services-screen/components/agreement_header.dart';
import 'package:app/screens/form-info-agreement-services-screen/components/room_summary_card.dart';
import 'package:app/screens/form-info-agreement-services-screen/components/section_title_row.dart';
import 'package:app/screens/form-info-agreement-services-screen/components/rent_price_section.dart';
import 'package:app/screens/form-info-agreement-services-screen/components/utilities_section.dart';
import 'package:app/screens/form-info-agreement-services-screen/components/add_on_services_section.dart';
import 'package:app/screens/form-info-agreement-services-screen/components/equipment_section.dart';
import 'package:app/screens/form-info-agreement-services-screen/components/agreement_bottom_bar.dart';
import 'package:app/screens/contract-preview-screen/contract_preview_screen.dart';

class AgreementUiScreen extends StatefulWidget {
  const AgreementUiScreen({super.key});

  @override
  State<AgreementUiScreen> createState() => _AgreementUiScreenState();
}

class _AgreementUiScreenState extends State<AgreementUiScreen> {
  final TextEditingController startDateCtl = TextEditingController();
  final TextEditingController rentPriceCtl = TextEditingController();
  final elecPriceCtl = TextEditingController();
  final waterPriceCtl = TextEditingController();
  final parkingFeeCtl = TextEditingController();
  @override
  void dispose() {
    rentPriceCtl.dispose();

    startDateCtl.dispose();
    elecPriceCtl.dispose();
    waterPriceCtl.dispose();
    parkingFeeCtl.dispose();
    super.dispose();
  }
  void _goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ContractPreviewScreen()),
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
          'Thỏa thuận giá và dịch vụ',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AgreementHeader(step: 3, total: 3),
            const SizedBox(height: 14),

            const RoomSummaryCard(
              title: 'Phòng 101 - Khu A',
              subtitle:
                  '123 đường Nguyễn Trãi, Phường Bến Thành,\nQuận 1, TP. HCM',
            ),

            const SizedBox(height: 18),
            const SectionTitleRow(
              icon: Icons.price_change_outlined,
              title: 'Giá thuê',
            ),
            const SizedBox(height: 10),

            RentPriceSectionUi(
              rentPriceCtl: rentPriceCtl,
              startDateCtl: startDateCtl,
            ),

            const SizedBox(height: 18),
            const SectionTitleRow(
              icon: Icons.bolt_outlined,
              title: 'Chỉ số điện & nước',
            ),
            const SizedBox(height: 10),
            UtilitiesSectionUi(
            elecPriceCtl: elecPriceCtl,
            waterPriceCtl: waterPriceCtl,
            parkingFeeCtl: parkingFeeCtl,
          ),

            const SizedBox(height: 18),
            const SectionTitleRow(
              icon: Icons.add_circle_outline,
              title: 'Dịch vụ bổ sung',
            ),
            const SizedBox(height: 10),
            const AddOnServicesSectionUi(),

            const SizedBox(height: 18),
            const SectionTitleRow(
              icon: Icons.inventory_2_outlined,
              title: 'Vật dụng trang bị',
            ),
            const SizedBox(height: 10),
            const EquipmentSectionUi(),
          ],
        ),
      ),
      bottomNavigationBar:  AgreementBottomBar(
        text: 'Xác nhận & Gửi yêu cầu',
        onNext: () => _goNext(context),
      ),
    );
  }
}