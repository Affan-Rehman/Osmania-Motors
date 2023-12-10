part of 'profile_bloc.dart';

abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

class LoadedProfileState extends ProfileState {
  LoadedProfileState(this.userInfo, this.isFavouritesEmpty, this.isListingsEmpty);

  UserInfo userInfo;
  bool? isFavouritesEmpty;
  bool? isListingsEmpty;
}

class ErrorProfileState extends ProfileState {}

class EmptyFavouritesState extends ProfileState {}

class EmptyInventoryState extends ProfileState {}

class LoadingDeleteCarState extends ProfileState {}

class SuccessDeleteCarState extends ProfileState {
  SuccessDeleteCarState({this.response});

  final dynamic response;
}

class ErrorDeleteCarState extends ProfileState {
  ErrorDeleteCarState({this.message});

  final dynamic message;
}

class LoadingGetEditCar extends ProfileState {}

class SuccessGetEditCarDataState extends ProfileState {
  SuccessGetEditCarDataState({required this.response});

  Map<String, dynamic> response = {};
}

class SuccessRemovedCarState extends ProfileState {}
