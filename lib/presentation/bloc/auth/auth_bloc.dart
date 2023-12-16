import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/data/models/auth/auth.dart';
import 'package:motors_app/data/repositories/auth_repository_impl.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(InitialAuthState()) {
    on<LoginEvent>((event, emit) async {
      emit(LoadingAuthState());

      final auth = await authRepository.signIn(event.login, event.password);
      if (auth.code != 200) {
        emit(ErrorAuthState(auth.message));
      } else {
        emit(SuccessAuthState());
      }
    });
// Update your AuthBloc to handle Google and Apple sign-in events

    on<SignInWithGoogleEvent>((event, emit) async {
      emit(LoadingAuthState());

      final user = await authRepository.signInWithGoogle();

      if (user.userEmail == '') {
        emit(ErrorAuthState(''));
      } else {
        emit(SuccessAuthState());
        appleLogin = false;
      }
    });

    on<SignInWithAppleEvent>((event, emit) async {
      emit(LoadingAuthState());

      final user = await authRepository.signInWithApple();
      if (user.userEmail == '') {
        emit(ErrorAuthState(''));
      } else {
        emit(SuccessAuthState());
        appleLogin = true;
      }
    });

    on<Logout>((event, emit) async => await preferences.remove('token'));

    on<SignUpEvent>((event, emit) async {
      emit(LoadingSignUpState());
      Auth auth = await authRepository.signUp(
        event.login,
        event.name,
        event.surname,
        event.phone,
        event.email,
        event.password,
        event.avatar,
      );

      if (auth.code == 200) {
        emit(SuccessAuthState());
        appleLogin = false;
      } else {
        emit(ErrorSignUpState(auth.message));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(LoadingUpdateUserState());

      try {
        await authRepository.updateProfile(
          event.login,
          event.name,
          event.surname,
          event.phone,
          event.email,
          event.password,
          event.avatar,
          event.userId,
          event.userToken,
        );

        emit(UpdatedUserState());
      } on DioException catch (e) {
        emit(ErrorUpdateUserState(e.response));
        log('Error Update Profile Info: ${e.response}');
      }
    });
  }

  final AuthRepository authRepository;
}
