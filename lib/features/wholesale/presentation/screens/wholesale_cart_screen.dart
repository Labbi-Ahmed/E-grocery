import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/wholesale_cart_item_model.dart';
import '../cubit/wholesale_cubit.dart';
import '../cubit/wholesale_state.dart';

class WholesaleCartScreen extends StatelessWidget {
  const WholesaleCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myCart),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              AppStrings.wholesale,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.accentDark,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<WholesaleCubit, WholesaleState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 64, color: AppColors.textHint),
                  SizedBox(height: 16),
                  Text('Your wholesale cart is empty',
                      style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = state.cartItems[index];
                    return _WholesaleCartItem(
                      item: item,
                      onQuantityChanged: (qty) => context
                          .read<WholesaleCubit>()
                          .updateCartQuantity(item.id, qty),
                      onRemove: () => context
                          .read<WholesaleCubit>()
                          .removeCartItem(item.id),
                    );
                  },
                ),
              ),
              // Summary
              Container(
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
                  child: Column(
                    children: [
                      _row(AppStrings.subTotal, state.cartSubtotal.toCurrency),
                      const SizedBox(height: 6),
                      _row(AppStrings.shipping, state.cartShipping.toCurrency),
                      const Divider(height: 16),
                      _row(AppStrings.total, state.cartTotal.toCurrency,
                          isBold: true),
                      if (!state.allMeetMinOrder) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Some items do not meet minimum order quantity',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      AppButton(
                        text: AppStrings.proceedToCheckout,
                        onPressed: state.allMeetMinOrder
                            ? () => context.push('/checkout')
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: AppColors.textSecondary,
            )),
        Text(value,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.textPrimary,
            )),
      ],
    );
  }
}

class _WholesaleCartItem extends StatelessWidget {
  final WholesaleCartItemModel item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const _WholesaleCartItem({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: !item.meetsMinOrder
            ? Border.all(color: AppColors.error.withValues(alpha: 0.5))
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorWidget: (c, u, e) => Container(
                width: 60, height: 60,
                color: AppColors.surface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  '${item.pricePerUnit.toCurrency} / ${item.unit ?? "unit"}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!item.meetsMinOrder)
                  Text(
                    'Min: ${item.minOrderQuantity} units',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.total.toCurrency,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _qtyBtn(Icons.remove,
                      () => onQuantityChanged(item.quantity - 1),
                      item.quantity <= 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  _qtyBtn(Icons.add,
                      () => onQuantityChanged(item.quantity + 1), false),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, bool disabled) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 26, height: 26,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14,
            color: disabled ? AppColors.disabled : AppColors.primary),
      ),
    );
  }
}
