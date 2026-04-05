import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  final AuthRepository _authRepository;

  PasswordResetCubit(this._authRepository)
      : super(const PasswordResetState.initial());

  Future<void> sendOtp({required String email}) async {
    emit(state.copyWith(
      status: PasswordResetStatus.loading,
      email: email,
    ));

    final result = await _authRepository.forgotPassword(email: email);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: PasswordResetStatus.otpSent,
        email: email,
      )),
    );
  }

  Future<void> verifyOtp({required String otp}) async {
    emit(state.copyWith(status: PasswordResetStatus.loading));

    final result = await _authRepository.verifyOtp(
      email: state.email!,
      otp: otp,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: PasswordResetStatus.otpVerified,
        otp: otp,
      )),
    );
  }

  Future<void> resetPassword({required String password}) async {
    emit(state.copyWith(status: PasswordResetStatus.loading));

    final result = await _authRepository.resetPassword(
      email: state.email!,
      otp: state.otp!,
      password: password,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: PasswordResetStatus.resetSuccess,
      )),
    );
  }

  void reset() {
    emit(const PasswordResetState.initial());
  }
}
