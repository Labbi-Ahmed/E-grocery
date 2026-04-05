import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/wholesale_cubit.dart';
import '../cubit/wholesale_state.dart';

class WholesaleProductDetailScreen extends StatelessWidget {
  final String productId;

  const WholesaleProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WholesaleCubit, WholesaleState>(
      builder: (context, state) {
        final product = state.selectedProduct;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.details),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          body: state.status == WholesaleStatus.loading || product == null
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (c, u, e) => Container(
                          height: 300,
                          color: AppColors.surface,
                          child: const Icon(Icons.image, size: 48,
                              color: AppColors.textHint),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Wholesale price
                            Row(
                              children: [
                                Text(
                                  product.priceForQuantity(state.detailQuantity)
                                      .toCurrency,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (product.unit != null)
                                  Text(
                                    ' / ${product.unit}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                const SizedBox(width: 12),
                                Text(
                                  product.retailPrice.toCurrency,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textHint,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Rating
                            if (product.rating != null)
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 16,
                                      color: AppColors.ratingStar),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rating!.toStringAsFixed(1)} (${product.reviewCount ?? 0})',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            // MOQ badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Min. Order: ${product.minOrderQuantity} units',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentDark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Quantity selector
                            Row(
                              children: [
                                const Text(
                                  'Quantity:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                _buildQtyButton(
                                  context,
                                  Icons.remove,
                                  () => context
                                      .read<WholesaleCubit>()
                                      .setDetailQuantity(
                                          state.detailQuantity - 1),
                                  state.detailQuantity <=
                                      product.minOrderQuantity,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    '${state.detailQuantity}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                _buildQtyButton(
                                  context,
                                  Icons.add,
                                  () => context
                                      .read<WholesaleCubit>()
                                      .setDetailQuantity(
                                          state.detailQuantity + 1),
                                  false,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Pricing tiers
                            if (product.pricingTiers.isNotEmpty) ...[
                              const Text(
                                'Bulk Pricing',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.divider),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    // Header
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: const BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(8)),
                                      ),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                            child: Text('Quantity',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13)),
                                          ),
                                          Text('Price / Unit',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                    ...product.pricingTiers.map((tier) {
                                      final isActive =
                                          state.detailQuantity >=
                                              tier.minQuantity &&
                                          (tier.maxQuantity == null ||
                                              state.detailQuantity <=
                                                  tier.maxQuantity!);
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? AppColors.primary
                                                  .withValues(alpha: 0.08)
                                              : null,
                                          border: const Border(
                                            top: BorderSide(
                                                color: AppColors.divider,
                                                width: 0.5),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                tier.label,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: isActive
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                  color: isActive
                                                      ? AppColors.primary
                                                      : AppColors
                                                          .textSecondary,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              tier.pricePerUnit.toCurrency,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: isActive
                                                    ? AppColors.primary
                                                    : AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                            // Description
                            if (product.description != null) ...[
                              const SizedBox(height: 20),
                              const Text('Description',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                              const SizedBox(height: 8),
                              Text(
                                product.description!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            // Shipping
                            if (product.shippingInfo != null) ...[
                              const SizedBox(height: 16),
                              const Text('Shipping',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                              const SizedBox(height: 8),
                              Text(
                                product.shippingInfo!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            // Additional info
                            if (product.additionalInfo.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Text('Additional Information',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                              const SizedBox(height: 8),
                              ...product.additionalInfo.entries.map((e) =>
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text(e.key,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .textSecondary))),
                                        Expanded(
                                            flex: 3,
                                            child: Text(e.value,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                      ],
                                    ),
                                  )),
                            ],
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: product != null
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: AppButton(
                      text: AppStrings.addToCart,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${state.detailQuantity}x ${product.name} added to wholesale cart',
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildQtyButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
    bool disabled,
  ) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: disabled ? AppColors.disabled : AppColors.primary,
        ),
      ),
    );
  }
}
