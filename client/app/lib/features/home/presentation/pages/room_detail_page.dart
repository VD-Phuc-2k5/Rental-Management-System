import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/collapse_text.dart';
import '../../../../core/config/router/route_constants.dart';
import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/format_currency.dart';
import '../blocs/browse_room_detail/browse_room_detail_bloc.dart';

const _kAmenityCodes = <String, (IconData, String)>{
  'AC': (Icons.ac_unit, 'Điều hòa'),
  'BED': (Icons.bed, 'Giường'),
  'WASHING_MACHINE': (Icons.local_laundry_service, 'Máy giặt'),
  'BALCONY': (Icons.balcony, 'Ban công'),
  'WATER_HEATER': (Icons.water, 'Nóng lạnh'),
  'FRIDGE': (Icons.kitchen, 'Tủ lạnh'),
  'TABLE_CHAIR': (Icons.chair, 'Bàn ghế'),
  'TV': (Icons.tv, 'TV'),
  'WARDROBE': (Icons.door_sliding, 'Tủ quần áo'),
  'KITCHEN': (Icons.restaurant, 'Bếp'),
  'WIFI': (Icons.wifi, 'Wi-Fi'),
};

class RoomDetailPage extends StatelessWidget {
  const RoomDetailPage({
    super.key,
    required this.roomId,
    required this.isLandlord,
  });

  final String roomId;
  final bool isLandlord;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<BrowseRoomDetailBloc>()
            ..add(BrowseRoomDetailFetched(roomId: roomId)),
      child: _RoomDetailView(roomId: roomId),
    );
  }
}

class _RoomDetailView extends StatelessWidget {
  const _RoomDetailView({required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue700),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Chi tiết phòng',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
      body: BlocBuilder<BrowseRoomDetailBloc, BrowseRoomDetailState>(
        builder: (context, state) {
          return switch (state) {
            BrowseRoomDetailLoadInProgress() => const Center(
              child: CircularProgressIndicator(),
            ),
            BrowseRoomDetailLoadFailure() => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Có lỗi xảy ra khi tải chi tiết phòng.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<BrowseRoomDetailBloc>().add(
                      BrowseRoomDetailFetched(roomId: roomId),
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            BrowseRoomDetailLoadSuccess(:final data) => SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ImageCarousel(
                      imageUrls: data.images.map((img) => img.url).toList(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _RoomHeading(
                            title: data.title,
                            price: data.monthlyRent,
                          ),
                          const SizedBox(height: 10),
                          _RoomInfoSection(
                            electricPrice: data.electricityRatePerKwh,
                            waterPrice: data.waterRatePerM3,
                            address: data.fullAddress,
                            area: data.areaSqm,
                            hasFurniture: data.hasFurniture,
                          ),
                          if (data.includedAmenityCodes.isNotEmpty ||
                              data.addonAmenities.isNotEmpty) ...[
                            _RoomAmenitiesSection(
                              includedCodes: data.includedAmenityCodes,
                              addonAmenities: data.addonAmenities
                                  .map((a) => (a.code, a.monthlyPrice))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (data.description != null &&
                              data.description!.isNotEmpty) ...[
                            _RoomDescriptionSection(
                              description: data.description!,
                            ),
                            const SizedBox(height: 12),
                          ],
                          _RoomOwnerRow(
                            ownerName: data.landlordName,
                            avatarUrl: data.landlordAvatarUrl,
                          ),
                          const SizedBox(height: 64),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
      bottomNavigationBar:
          BlocBuilder<BrowseRoomDetailBloc, BrowseRoomDetailState>(
            builder: (context, state) {
              if (state is! BrowseRoomDetailLoadSuccess) {
                return const SizedBox.shrink();
              }
              return _ConfirmBookRoomBar(
                price: state.data.monthlyRent,
                roomId: roomId,
              );
            },
          ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  const _ImageCarousel({required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    if (widget.imageUrls.length < 2) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final next = (_currentPage + 1) % widget.imageUrls.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return SizedBox(
        height: 280,
        child: Container(
          color: AppColors.slate200,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, size: 64, color: AppColors.slate400),
                SizedBox(height: 12),
                Text(
                  'Chưa có hình ảnh',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => Image.network(
              widget.imageUrls[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                        : null,
                    color: AppColors.blue700,
                  ),
                );
              },
              errorBuilder: (_, _, _) => Container(
                color: AppColors.slate200,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: AppColors.slate400,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.share_outlined,
                color: AppColors.slate500,
                size: 20,
              ),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => GestureDetector(
                    onTap: () => _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? AppColors.white
                            : AppColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoomHeading extends StatelessWidget {
  const _RoomHeading({required this.title, required this.price});

  final String title;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                formatVND(price.toInt()),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue700,
                ),
              ),
              const Text(
                '/tháng',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomInfoSection extends StatelessWidget {
  const _RoomInfoSection({
    required this.electricPrice,
    required this.waterPrice,
    required this.address,
    required this.area,
    required this.hasFurniture,
  });

  final double electricPrice;
  final double waterPrice;
  final String address;
  final double area;
  final bool hasFurniture;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt_outlined, size: 20, color: AppColors.blue700),
            const SizedBox(width: 8),
            Text(
              'Điện: ${formatVND(electricPrice.toInt())}/kWh',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 24),
            const Icon(
              Icons.water_drop_outlined,
              size: 20,
              color: AppColors.blue700,
            ),
            const SizedBox(width: 8),
            Text(
              'Nước: ${formatVND(waterPrice.toInt())}/m3',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.slate100,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: AppColors.blue700,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                address,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.slate500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _FeatureChip(Icons.square_foot_outlined, '${area.toInt()}m²'),
            if (hasFurniture)
              const _FeatureChip(Icons.weekend_outlined, 'Có nội thất'),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: 1,
          color: AppColors.slate200,
        ),
      ],
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.blue700),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.blue700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomDescriptionSection extends StatefulWidget {
  const _RoomDescriptionSection({required this.description});

  final String description;

  @override
  State<_RoomDescriptionSection> createState() =>
      _RoomDescriptionSectionState();
}

class _RoomDescriptionSectionState extends State<_RoomDescriptionSection> {
  bool _isExpanded = false;
  static const int _wordLimit = 30;

  @override
  Widget build(BuildContext context) {
    final wordCount = CollapseText.getWordCount(widget.description);
    final shouldTruncate = wordCount > _wordLimit;
    final displayText = shouldTruncate && !_isExpanded
        ? CollapseText.getTruncatedText(widget.description, _wordLimit)
        : widget.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mô tả',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.slate500,
              height: 1.5,
            ),
            children: [
              TextSpan(text: displayText),
              if (shouldTruncate)
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        _isExpanded ? ' Thu gọn' : ' Xem thêm',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoomOwnerRow extends StatelessWidget {
  const _RoomOwnerRow({required this.ownerName, this.avatarUrl});

  final String ownerName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.slate200, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: avatarUrl != null
                    ? Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.slate200,
                          child: const Icon(
                            Icons.person,
                            size: 32,
                            color: AppColors.slate400,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.slate200,
                        child: const Icon(
                          Icons.person,
                          size: 32,
                          color: AppColors.slate400,
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ownerName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Chủ trọ • Phản hồi nhanh',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.slate300, width: 1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.phone, size: 24, color: AppColors.blue700),
        ),
      ],
    );
  }
}

class _RoomAmenitiesSection extends StatelessWidget {
  const _RoomAmenitiesSection({
    required this.includedCodes,
    required this.addonAmenities,
  });

  final List<String> includedCodes;
  final List<(String, double)> addonAmenities;

  @override
  Widget build(BuildContext context) {
    final included = includedCodes
        .where((c) => _kAmenityCodes.containsKey(c))
        .map((c) => (c, _kAmenityCodes[c]!))
        .toList();

    final addons = addonAmenities
        .where((a) => _kAmenityCodes.containsKey(a.$1))
        .map((a) => (a.$1, _kAmenityCodes[a.$1]!, a.$2))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (included.isNotEmpty) ...[
          const Text(
            'Tiện ích',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
            children: included.map((entry) {
              final (_, meta) = entry;
              final (icon, label) = meta;
              return Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, size: 24, color: AppColors.blue700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 11,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
        if (addons.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Tiện ích thuê thêm',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: addons.map((entry) {
              final (_, meta, price) = entry;
              final (icon, label) = meta;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.blue700.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: AppColors.blue700),
                    const SizedBox(width: 4),
                    Text(
                      '$label +${formatCurrency(price)}/tháng',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blue700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: 1,
          color: AppColors.slate200,
        ),
      ],
    );
  }
}

class _ConfirmBookRoomBar extends StatelessWidget {
  const _ConfirmBookRoomBar({required this.price, required this.roomId});

  final double price;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Giá thuê',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatCurrency(price),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue700,
                      ),
                    ),
                    const Text(
                      '/tháng',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.pushNamed(
                    RouteNames.scheduleViewing,
                    extra: {'roomId': roomId},
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue700,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: Colors.black.withValues(alpha: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text(
                    'Đặt lịch xem phòng',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
