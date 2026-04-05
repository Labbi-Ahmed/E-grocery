import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@email.com');
  final _phoneController = TextEditingController(text: '(415) 555-0128');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
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
              // Avatar
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, size: 50, color: AppColors.primaryDark),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
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
                controller: _emailController,
                label: AppStrings.email,
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
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
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: AppStrings.save,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated!'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
