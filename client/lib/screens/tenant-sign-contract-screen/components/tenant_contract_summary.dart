import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class TenantContractSummaryCard extends StatelessWidget {
  const TenantContractSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeroImage(),
            SizedBox(height: 12),
            _MetaTitle(),
            SizedBox(height: 10),
            Divider(height: 1),
            SizedBox(height: 10),
            _InfoSection(),
            SizedBox(height: 10),
            _PreviewBox(),
          ],
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.blue950, AppColors.slate500],
          ),
        ),
        child: Stack(
          children: [
             Positioned.fill(
              child: Image.asset(
                'assets/images/apartment.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 14,
              bottom: 14,
              right: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'MÃ CĂN HỘ',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'P.302 - Nhà Trọ Xanh',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaTitle extends StatelessWidget {
  const _MetaTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text('Ngày lập', style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w500,)),
        Spacer(),
        Text('24/10/2023', style: TextStyle(color: AppColors.blue950, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'THÔNG TIN CHÍNH',
          style: TextStyle(
            color: AppColors.blue700,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 10),

        _InfoRow(label: 'Bên A (Chủ nhà):', value: 'Nguyễn Văn A'),
        _InfoRow(label: 'Bên B (Người thuê):', value: 'Trần Thị B'),
        _InfoRow(label: 'Thời hạn:', value: '12 tháng'),
        _InfoRowBlue(label: 'Giá thuê:', value: '4.500.000 đ/tháng'),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.slate500,fontWeight: FontWeight.w400)),
          ),
          Text(value,maxLines: 2, style: const TextStyle(color: AppColors.blue950, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class _InfoRowBlue extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRowBlue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.slate500,fontWeight: FontWeight.w400)),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.blue700,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewBox extends StatelessWidget {
  const _PreviewBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Điều 1: Đối tượng hợp đồng. Bên A đồng ý cho bên\nB thuê và bên B đồng ý thuê toàn bộ phần diện tích\nsử dụng của căn hộ...',
            style: TextStyle(color: AppColors.slate500, height: 1.25,fontWeight: FontWeight.w400,fontSize: 12),
          ),
          const SizedBox(height: 8),
          const Text(
            'Điều 2: Giá cả và phương thức thanh toán. Tiền...',
            style: TextStyle(color: AppColors.slate500, height: 1.25,fontWeight: FontWeight.w400,fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text(
                'Xem toàn bộ hợp đồng',
                style: TextStyle(
                  color: AppColors.blue700,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.open_in_new_rounded, size: 16, color: AppColors.blue700),
            ],
          )
        ],
      ),
    );
  }
}