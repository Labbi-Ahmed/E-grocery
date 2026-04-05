import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  const AuthState.initial() : this();

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}

// Separate states for password reset flow
enum PasswordResetStatus {
  initial,
  loading,
  otpSent,
  otpVerified,
  resetSuccess,
  error,
}

class PasswordResetState extends Equatable {
  final PasswordResetStatus status;
  final String? email;
  final String? otp;
  final String? errorMessage;

  const PasswordResetState({
    this.status = PasswordResetStatus.initial,
    this.email,
    this.otp,
    this.errorMessage,
  });

  const PasswordResetState.initial() : this();

  PasswordResetState copyWith({
    PasswordResetStatus? status,
    String? email,
    String? otp,
    String? errorMessage,
  }) {
    return PasswordResetState(
      status: status ?? this.status,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, email, otp, errorMessage];
}
