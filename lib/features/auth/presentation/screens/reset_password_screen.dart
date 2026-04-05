import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/auth_state.dart';
import '../cubit/password_reset_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onReset(PasswordResetCubit cubit) {
    if (_formKey.currentState?.validate() ?? false) {
      cubit.resetPassword(password: _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<PasswordResetCubit>();
        // Pre-set email and otp so resetPassword can use them
        cubit.sendOtp(email: widget.email);
        cubit.verifyOtp(otp: widget.otp);
        return cubit;
      },
      child: BlocConsumer<PasswordResetCubit, PasswordResetState>(
        listener: (context, state) {
          if (state.status == PasswordResetStatus.resetSuccess) {
            context.go('/password-success');
          } else if (state.status == PasswordResetStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(state.errorMessage ?? 'Password reset failed'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.resetPassword),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'New Password',
                        hint: 'Enter new password',
                        obscureText: true,
                        validator: Validators.password,
                        prefixIcon:
                            const Icon(Icons.lock_outlined, size: 20),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _confirmPasswordController,
                        label: AppStrings.confirmPassword,
                        hint: 'Confirm new password',
                        obscureText: true,
                        validator: (v) => Validators.confirmPassword(
                            v, _passwordController.text),
                        prefixIcon:
                            const Icon(Icons.lock_outlined, size: 20),
                        textInputAction: TextInputAction.done,
                      ),
                      const Spacer(),
                      AppButton(
                        text: AppStrings.continueText,
                        onPressed: () => _onReset(
                            context.read<PasswordResetCubit>()),
                        isLoading:
                            state.status == PasswordResetStatus.loading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
