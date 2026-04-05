import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/order_model.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.myOrders),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            onTap: (index) {
              final tabs = ['active', 'completed', 'cancelled'];
              context.read<OrdersCubit>().changeTab(tabs[index]);
            },
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state.orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        size: 64, color: AppColors.textHint),
                    SizedBox(height: 16),
                    Text('No orders yet',
                        style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                return _OrderCard(order: state.orders[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/order/${order.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(order.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _statusColor(order.status)),
                  ),
                  child: Text(
                    order.statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _statusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order.date,
              style: const TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
            const SizedBox(height: 12),
            // Items preview
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  ...order.items.take(3).map((item) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorWidget: (c, u, e) => Container(
                              width: 40, height: 40,
                              color: AppColors.surface,
                              child: const Icon(Icons.image, size: 16, color: AppColors.textHint),
                            ),
                          ),
                        ),
                      )),
                  if (order.items.length > 3)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '+${order.items.length - 3}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    order.total.toCurrency,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (order.status == OrderStatus.processing ||
                    order.status == OrderStatus.shipped)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/track-order/${order.id}'),
                      child: const Text(AppStrings.trackOrder),
                    ),
                  ),
                if (order.status == OrderStatus.delivered) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text(AppStrings.reOrder),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(AppStrings.rateOrder),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return AppColors.primary;
      case OrderStatus.shipped:
        return AppColors.info;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }
}
