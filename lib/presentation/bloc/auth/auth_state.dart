part of 'auth_bloc.dart';

abstract class AuthState {}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class LoadingSignUpState extends AuthState {}

class SuccessAuthState extends AuthState {}

class LoadingUpdateUserState extends AuthState {}

class UpdatedUserState extends AuthState {}

class ErrorAuthState extends AuthState {
  ErrorAuthState(this.message);

  dynamic message;
}

class ErrorSignUpState extends AuthState {
  ErrorSignUpState(this.message);

  dynamic message;
}

class ErrorUpdateUserState extends AuthState {
  ErrorUpdateUserState(this.message);

  dynamic message;
}
