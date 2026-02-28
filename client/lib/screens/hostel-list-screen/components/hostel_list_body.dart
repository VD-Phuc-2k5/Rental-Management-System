import 'package:flutter/material.dart';
import 'summary_section.dart';
import 'hostel_card.dart';

class HostelListBody extends StatelessWidget {
  const HostelListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            SummarySection(),
            SizedBox(height: 16),
            HostelCard(
              title: "Khu A – 123 Nguyễn Trãi, Q5",
              statusText: "Chưa có phòng",
            ),
            SizedBox(height: 16),
            HostelCard(
              title: "Khu B – 45 Võ Văn Tần, Q3",
              statusText: "2/4 phòng đang thuê",
              blueBlocks: 4,
              orangeBlocks: 1,
              greyBlocks: 6,
            ),
          ],
        ),
      ),
    );
  }
}