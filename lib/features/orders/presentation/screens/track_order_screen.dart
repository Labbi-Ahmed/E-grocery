import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/order_model.dart';
import '../cubit/orders_cubit.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;

  const TrackOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final order = context.read<OrdersCubit>().state.orders
        .where((o) => o.id == orderId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.trackOrder),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: order == null
          ? const Center(child: Text('Order not found'))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.date,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Timeline
                  ...List.generate(order.trackingSteps.length, (index) {
                    final step = order.trackingSteps[index];
                    final isLast = index == order.trackingSteps.length - 1;
                    return _TimelineStep(
                      step: step,
                      isLast: isLast,
                    );
                  }),
                ],
              ),
            ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final TrackingStep step;
  final bool isLast;

  const _TimelineStep({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + line
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: step.isCompleted
                      ? AppColors.primary
                      : AppColors.divider,
                  shape: BoxShape.circle,
                ),
                child: step.isCompleted
                    ? const Icon(Icons.check, size: 12, color: AppColors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    constraints: const BoxConstraints(minHeight: 40),
                    color: step.isCompleted
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: step.isCompleted
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                  if (step.subtitle != null)
                    Text(
                      step.subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (step.date != null)
                    Text(
                      step.date!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
