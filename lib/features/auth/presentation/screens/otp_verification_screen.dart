import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/auth_state.dart';
import '../cubit/password_reset_cubit.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  String _currentOtp = '';
  late Timer _timer;
  int _resendSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _onVerify(PasswordResetCubit cubit) {
    if (_currentOtp.length == 4) {
      cubit.verifyOtp(otp: _currentOtp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PasswordResetCubit>()
        ..sendOtp(email: widget.email), // Initialize with email context
      child: Builder(
        builder: (context) {
          return BlocConsumer<PasswordResetCubit, PasswordResetState>(
            listener: (context, state) {
              if (state.status == PasswordResetStatus.otpVerified) {
                context.push('/reset-password', extra: {
                  'email': widget.email,
                  'otp': _currentOtp,
                });
              } else if (state.status == PasswordResetStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(state.errorMessage ?? 'OTP verification failed'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text(AppStrings.otpTitle),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => context.pop(),
                  ),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.otpSubtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        if (widget.email.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                        const SizedBox(height: 40),
                        PinCodeTextField(
                          appContext: context,
                          length: 4,
                          controller: _otpController,
                          onChanged: (value) =>
                              setState(() => _currentOtp = value),
                          onCompleted: (_) => _onVerify(
                              context.read<PasswordResetCubit>()),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(12),
                            fieldHeight: 56,
                            fieldWidth: 56,
                            activeFillColor: AppColors.white,
                            inactiveFillColor: AppColors.surface,
                            selectedFillColor: AppColors.white,
                            activeColor: AppColors.primary,
                            inactiveColor: AppColors.divider,
                            selectedColor: AppColors.primary,
                          ),
                          enableActiveFill: true,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive code? ",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (_canResend)
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<PasswordResetCubit>()
                                      .sendOtp(email: widget.email);
                                  _startResendTimer();
                                },
                                child: const Text(
                                  'Resend',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            else
                              Text(
                                'Resend in ${_resendSeconds}s',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        AppButton(
                          text: AppStrings.verifyOtp,
                          onPressed: _currentOtp.length == 4
                              ? () => _onVerify(
                                  context.read<PasswordResetCubit>())
                              : null,
                          isLoading:
                              state.status == PasswordResetStatus.loading,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
