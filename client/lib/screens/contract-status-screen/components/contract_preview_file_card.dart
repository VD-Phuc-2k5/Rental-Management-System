import 'package:flutter/material.dart';

class ContractPreviewFileCard extends StatelessWidget {
  const ContractPreviewFileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeaderRow(),
            SizedBox(height: 12),
            _PreviewArea(),
            SizedBox(height: 10),
            _FileMetaRow(),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Bản xem trước hợp đồng',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Chưa ký',
            style: TextStyle(
              color: Color(0xFF647487),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _PreviewArea extends StatelessWidget {
  const _PreviewArea();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: const [
          _SkeletonDocument(),
          Center(child: _EyeButton()),
        ],
      ),
    );
  }
}

class _EyeButton extends StatelessWidget {
  const _EyeButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF195AA4)),
    );
  }
}

/// giả lập cái hình preview pdf (UI-only)
class _SkeletonDocument extends StatelessWidget {
  const _SkeletonDocument();

  Widget _line({double? w, double h = 10}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _line(w: 90, h: 12),
          const SizedBox(height: 14),
          _line(w: double.infinity, h: 18),
          const SizedBox(height: 18),
          _line(w: 220),
          const SizedBox(height: 12),
          _line(w: 190),
          const SizedBox(height: 12),
          _line(w: 260),
          const SizedBox(height: 12),
          _line(w: 210),
          const SizedBox(height: 12),
          _line(w: 240),
          const SizedBox(height: 26),
          _line(w: 120, h: 14),
          const SizedBox(height: 18),
          _line(w: double.infinity, h: 14),
          const SizedBox(height: 12),
          _line(w: 180, h: 14),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.edit_document, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 6),
                    _line(w: 80, h: 10),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAEFF4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _line(w: 80, h: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FileMetaRow extends StatelessWidget {
  const _FileMetaRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Text(
            'HD-2026-0301-A301.pdf',
            style: TextStyle(color: Color(0xFF647487), fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          '2.4 MB',
          style: TextStyle(color: Color(0xFF647487), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}