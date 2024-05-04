part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {}

final class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

final class AuthInProgress extends AuthState {
  @override
  List<Object?> get props => [];
}

final class AuthSuccess extends AuthState {
  final String message;
  final User user;

  AuthSuccess({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

final class AuthFail extends AuthState {
  final AuthException exception;

  AuthFail({required this.exception});

  @override
  List<Object?> get props => [exception];
}
