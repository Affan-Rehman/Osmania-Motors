part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  LoginEvent(this.login, this.password);

  final dynamic login;
  final dynamic password;
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignInWithAppleEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  SignUpEvent(
      {this.login,
      this.name,
      this.surname,
      this.phone,
      this.email,
      this.password,
      this.avatar});

  final dynamic login;
  final dynamic name;
  final dynamic surname;
  final dynamic phone;
  final dynamic email;
  final dynamic password;
  File? avatar;
}

class UpdateProfileEvent extends AuthEvent {
  UpdateProfileEvent({
    this.login,
    this.name,
    this.surname,
    this.phone,
    this.email,
    this.password,
    this.avatar,
    this.userId,
    this.userToken,
  });

  final dynamic login;
  final dynamic name;
  final dynamic surname;
  final dynamic phone;
  final dynamic email;
  final dynamic password;
  File? avatar;
  final dynamic userId;
  final dynamic userToken;
}

class Logout extends AuthEvent {}
