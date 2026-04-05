import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../cart/data/models/address_model.dart';
import '../../../cart/presentation/cubit/checkout_cubit.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({super.key});

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _zipController = TextEditingController();
  String _selectedCountry = 'United States';

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _phoneController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final address = AddressModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: 'Home',
        fullName: _nameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _selectedCountry,
        zipCode: _zipController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      context.read<CheckoutCubit>().addAddress(address);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.newAddress),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _nameController,
                label: AppStrings.fullName,
                hint: 'Enter your full name',
                validator: (v) => Validators.required(v, 'Full name'),
                prefixIcon: const Icon(Icons.person_outlined, size: 20),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _addressController,
                label: 'Full Address',
                hint: 'Type your full address',
                validator: (v) => Validators.required(v, 'Address'),
                prefixIcon:
                    const Icon(Icons.location_on_outlined, size: 20),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Country',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    items: const [
                      DropdownMenuItem(
                        value: 'United States',
                        child: Text('United States'),
                      ),
                      DropdownMenuItem(
                        value: 'Nigeria',
                        child: Text('Nigeria'),
                      ),
                      DropdownMenuItem(
                        value: 'Ghana',
                        child: Text('Ghana'),
                      ),
                      DropdownMenuItem(
                        value: 'Kenya',
                        child: Text('Kenya'),
                      ),
                      DropdownMenuItem(
                        value: 'South Africa',
                        child: Text('South Africa'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedCountry = v!),
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.flag_outlined, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _stateController,
                label: 'State',
                hint: 'Enter state',
                validator: (v) => Validators.required(v, 'State'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _cityController,
                label: 'City',
                hint: 'Enter city',
                validator: (v) => Validators.required(v, 'City'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _phoneController,
                label: AppStrings.phoneNumber,
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
                prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _zipController,
                label: 'Zip Code',
                hint: 'Type your zip code',
                keyboardType: TextInputType.number,
                validator: Validators.zipCode,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: AppStrings.save,
                onPressed: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
