import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/order_model.dart';
import '../cubit/orders_cubit.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel? _order;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  void _loadOrder() {
    final result = context.read<OrdersCubit>().state.orders
        .where((o) => o.id == widget.orderId)
        .firstOrNull;
    if (result != null) {
      setState(() => _order = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: _order == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _order!.orderNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _order!.statusLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _order!.status == OrderStatus.delivered
                              ? AppColors.success
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _order!.date,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textHint),
                  ),
                  const Divider(height: 24),
                  // Items
                  ..._order!.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
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
                                  width: 60,
                                  height: 60,
                                  color: AppColors.surface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  if (item.variant != null)
                                    Text(
                                      item.variant!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  Text(
                                    'x${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              item.total.toCurrency,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const Divider(height: 24),
                  // Summary
                  _row(AppStrings.subTotal, _order!.subtotal.toCurrency),
                  const SizedBox(height: 8),
                  _row(AppStrings.shipping, _order!.shipping.toCurrency),
                  if (_order!.discount > 0) ...[
                    const SizedBox(height: 8),
                    _row(AppStrings.discount,
                        '-${_order!.discount.toCurrency}',
                        valueColor: AppColors.primary),
                  ],
                  const Divider(height: 24),
                  _row(AppStrings.total, _order!.total.toCurrency,
                      isBold: true),
                  // Address
                  if (_order!.address != null) ...[
                    const Divider(height: 24),
                    Text(AppStrings.shippingAddress,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Text(
                      _order!.address!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  // Track button
                  if (_order!.status == OrderStatus.processing ||
                      _order!.status == OrderStatus.shipped) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.push('/track-order/${_order!.id}'),
                        child: const Text(AppStrings.trackOrder),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _row(String label, String value,
      {bool isBold = false, Color? valueColor}) {
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
              color: valueColor ?? AppColors.textPrimary,
            )),
      ],
    );
  }
}
