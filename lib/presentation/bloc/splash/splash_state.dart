part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class InitialSplashState extends SplashState {
  InitialSplashState({this.logo});

  final dynamic logo;
}

class CloseSplashState extends SplashState {
  CloseSplashState(this.appSettings, this.isSigned);

  final AppSettings appSettings;
  final bool isSigned;
}

class ErrorSplashState extends SplashState {}
