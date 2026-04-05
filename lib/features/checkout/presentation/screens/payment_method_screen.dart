import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../cart/presentation/cubit/checkout_cubit.dart';
import '../../../cart/presentation/cubit/checkout_state.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  static const _methods = [
    _PaymentOption(
      id: 'paypal',
      name: 'Paypal',
      icon: Icons.account_balance_wallet,
    ),
    _PaymentOption(
      id: 'apple_pay',
      name: 'Apple Pay',
      icon: Icons.apple,
    ),
    _PaymentOption(
      id: 'google_pay',
      name: 'Google Pay',
      icon: Icons.g_mobiledata,
    ),
    _PaymentOption(
      id: 'card',
      name: 'Mastercard / Visa',
      icon: Icons.credit_card,
    ),
    _PaymentOption(
      id: 'bank',
      name: 'Bank',
      icon: Icons.account_balance,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state.status == CheckoutStatus.placed) {
          context.go('/order-confirmed');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.paymentMethod),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _methods.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final method = _methods[index];
                final isSelected =
                    state.selectedPaymentMethod == method.id;
                return GestureDetector(
                  onTap: () => context
                      .read<CheckoutCubit>()
                      .selectPaymentMethod(method.id),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.divider,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          method.icon,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            method.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Radio<String>(
                          value: method.id,
                          groupValue: state.selectedPaymentMethod,
                          activeColor: AppColors.primary,
                          onChanged: (v) => context
                              .read<CheckoutCubit>()
                              .selectPaymentMethod(v!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            return Container(
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
                  text: AppStrings.continuePayment,
                  isLoading: state.status == CheckoutStatus.placing,
                  onPressed: state.selectedPaymentMethod != null
                      ? () =>
                          context.read<CheckoutCubit>().placeOrder()
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PaymentOption {
  final String id;
  final String name;
  final IconData icon;

  const _PaymentOption({
    required this.id,
    required this.name,
    required this.icon,
  });
}
