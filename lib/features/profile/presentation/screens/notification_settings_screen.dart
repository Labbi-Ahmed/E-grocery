import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _newProducts = false;
  bool _priceAlerts = true;
  bool _deliveryUpdates = true;
  bool _newsletter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildToggle(
            'Order Updates',
            'Get notified about order status changes',
            _orderUpdates,
            (v) => setState(() => _orderUpdates = v),
          ),
          _buildToggle(
            'Promotions',
            'Receive promotional offers and deals',
            _promotions,
            (v) => setState(() => _promotions = v),
          ),
          _buildToggle(
            'New Products',
            'Be the first to know about new arrivals',
            _newProducts,
            (v) => setState(() => _newProducts = v),
          ),
          _buildToggle(
            'Price Alerts',
            'Get notified when prices drop',
            _priceAlerts,
            (v) => setState(() => _priceAlerts = v),
          ),
          _buildToggle(
            'Delivery Updates',
            'Real-time delivery tracking notifications',
            _deliveryUpdates,
            (v) => setState(() => _deliveryUpdates = v),
          ),
          _buildToggle(
            'Newsletter',
            'Weekly newsletter with recipes and tips',
            _newsletter,
            (v) => setState(() => _newsletter = v),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
