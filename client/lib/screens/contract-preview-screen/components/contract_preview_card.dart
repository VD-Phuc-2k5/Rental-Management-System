import 'package:flutter/material.dart';

class ContractPreviewCard extends StatelessWidget {
  const ContractPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _ContractHeader(),
            SizedBox(height: 12),
            Divider(height: 1),
            SizedBox(height: 12),

            _SectionTitle(text: 'I. BÊN CHO THUÊ (BÊN A)'),
            SizedBox(height: 10),
            _InfoRow(label: 'Họ và tên:', value: 'Nguyễn Văn A'),
            _InfoRow(label: 'CMND/CCCD:', value: '00109200xxxx'),
            _InfoRow(label: 'Điện thoại:', value: '0912345678'),

            SizedBox(height: 14),
            Divider(height: 1),
            SizedBox(height: 12),

            _SectionTitle(text: 'II. BÊN THUÊ (BÊN B)'),
            SizedBox(height: 10),
            _InfoRow(label: 'Họ và tên:', value: 'Trần Thị B'),
            _InfoRow(label: 'CMND/CCCD:', value: '03619500xxxx'),
            _InfoRow(label: 'Điện thoại:', value: '0987654321'),

            SizedBox(height: 14),
            Divider(height: 1),
            SizedBox(height: 12),

            _SectionTitle(text: 'III. CHI TIẾT THUÊ'),
            SizedBox(height: 10),
            _InfoRow(label: 'Địa chỉ:', value: 'Số 10, Ngõ 5, Đường Láng, Hà Nội'),
            _InfoRow(label: 'Phòng số:', value: '302'),
            _InfoRowBlue(label: 'Giá thuê:', value: '3.000.000 VND/tháng'),
            _InfoRow(label: 'Thời hạn:', value: '12 tháng'),

            SizedBox(height: 14),
            Divider(height: 1),
            SizedBox(height: 12),

            _SectionTitle(text: 'IV. ĐIỀU KHOẢN CHUNG'),
            SizedBox(height: 10),
            _Bullet(text: '1. Bên B có trách nhiệm thanh toán tiền thuê nhà đúng hạn vào ngày 05 hàng tháng.'),
            _Bullet(text: '2. Bên B phải giữ gìn vệ sinh chung, không gây ồn ào ảnh hưởng đến các phòng xung quanh sau 22h.'),
            _Bullet(text: '3. Tài sản trong phòng nếu hỏng hóc do lỗi Bên B thì Bên B phải đền bù theo giá thị trường.'),
            _Bullet(text: '4. Hợp đồng có hiệu lực kể từ ngày ký.'),

            SizedBox(height: 14),
            Divider(height: 1),
            SizedBox(height: 12),

            _Signatures(),
          ],
        ),
      ),
    );
  }
}

class _ContractHeader extends StatelessWidget {
  const _ContractHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
  child: Column(
    children: const [
      Text(
        'HỢP ĐỒNG THUÊ NHÀ',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF195AA4),
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: 0.2,
        ),
      ),
      SizedBox(height: 6),
      Text('Số: 2023/HDTN-001', style: TextStyle(color: Color(0xFF647487))),
      SizedBox(height: 2),
      Text(
        'Hà Nội, ngày 24 tháng 10 năm 2023',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF647487)),
      ),
    ],
  ),
);
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
      ),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 98,
            child: Text(label, style: const TextStyle(color: Color(0xFF647487))),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700),
            ),
          ),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 98,
            child: Text(label, style: const TextStyle(color: Color(0xFF647487))),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF195AA4),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF334155), height: 1.35),
      ),
    );
  }
}

class _Signatures extends StatelessWidget {
  const _Signatures();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: _SignatureBox(title: 'BÊN CHO THUÊ', name: 'Nguyễn Văn A'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _SignatureBox(title: 'BÊN THUÊ', name: 'Trần Thị B'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SignatureBox extends StatelessWidget {
  final String title;
  final String name;

  const _SignatureBox({required this.title, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF647487),
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 86,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFCBD5E1),
              width: 1.2,
              style: BorderStyle.solid,
            ),
          ),
          child: const Center(
            child: Text('Chưa ký', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}