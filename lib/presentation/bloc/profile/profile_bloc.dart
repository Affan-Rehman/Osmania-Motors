import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/data/models/add_car/add_car.dart';
import 'package:motors_app/data/models/user/user.dart';
import 'package:motors_app/data/repositories/add_car_repository.dart';
import 'package:motors_app/data/repositories/auth_repository_impl.dart';
import 'package:motors_app/data/repositories/car_detail_repository_impl.dart';

part 'profile_event.dart';

part 'profile_state.dart';

bool appleLogin = true;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this.authRepository) : super(InitialProfileState()) {
    on<LoadProfileEvent>((event, emit) async {
      bool isEmptyFavourites = true;
      bool isEmptyListings = true;
      try {
        UserInfo userInfo = await authRepository.getUserInfo(event.id);

        if (userInfo.favourites == null || userInfo.favourites!.isEmpty) {
          isEmptyFavourites = true;
        } else {
          isEmptyFavourites = false;
        }

        if (userInfo.listings.isEmpty) {
          isEmptyListings = true;
        } else {
          isEmptyListings = false;
        }
        if (appleLogin) {
          userInfo.author.name = "";
          userInfo.author.lastName = "";
        }

        emit(LoadedProfileState(userInfo, isEmptyFavourites, isEmptyListings));
      } on DioError catch (e) {
        log(e.toString());
      }
    });

    on<DeleteCarEvent>((event, emit) async {
      emit(LoadingDeleteCarState());
      AddedCarResponse response = await addCarRepository.deleteCar(event.data);
      if (response.message != 'Car deleted') {
        emit(ErrorDeleteCarState(message: 'Error'));
      } else {
        emit(SuccessDeleteCarState(response: response));
      }
    });

    on<GetEditCar>((event, emit) async {
      emit(LoadingGetEditCar());
      Map<String, dynamic> response =
          await addCarRepository.getEditCarData(event.carId);

      emit(SuccessGetEditCarDataState(response: response));
    });

    on<RemoveFavouriteCarEvent>((event, emit) async {
      await carDetailRepository.addToFavorite(
        event.userId,
        event.userToken,
        event.carId,
        'remove',
      );

      emit(SuccessRemovedCarState());
    });
  }

  final AuthRepository authRepository;
  AddCarRepository addCarRepository = AddCarRepositoryImpl();
  CarDetailRepository carDetailRepository = CarDetailRepositoryImpl();
}
