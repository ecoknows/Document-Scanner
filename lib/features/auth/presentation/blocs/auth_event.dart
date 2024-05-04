part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {}

final class SignUpUserStarted extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final PlatformFile? profileImage;

  SignUpUserStarted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.profileImage,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
        profileImage,
      ];
}

final class SignInUserStarted extends AuthEvent {
  final String email;
  final String password;

  SignInUserStarted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

final class SignOutUserStarted extends AuthEvent {
  SignOutUserStarted();

  @override
  List<Object?> get props => [];
}
