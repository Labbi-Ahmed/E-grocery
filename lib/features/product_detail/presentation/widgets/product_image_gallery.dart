import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;
  final String fallbackImage;

  const ProductImageGallery({
    super.key,
    required this.images,
    required this.fallbackImage,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  final _pageController = PageController();

  List<String> get _images =>
      widget.images.isNotEmpty ? widget.images : [widget.fallbackImage];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: _images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 48,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_images.length > 1)
          Positioned(
            bottom: 12,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: _images.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                activeDotColor: AppColors.primary,
                dotColor: AppColors.divider,
                expansionFactor: 3,
              ),
            ),
          ),
      ],
    );
  }
}
