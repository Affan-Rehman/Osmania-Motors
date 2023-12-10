part of 'add_car_bloc.dart';

abstract class AddCarState {}

class InitialAddCarState extends AddCarState {}

class LoadedAddCarState extends AddCarState {
  LoadedAddCarState({this.addCarResponse, this.locations});

  AddCarResponse? addCarResponse;
  List<Placemark>? locations;
}

class EmptyAddCarState extends AddCarState {}

class SuccessAddedCarState extends AddCarState {
  SuccessAddedCarState({required this.addedCarResponse});

  AddedCarResponse addedCarResponse;
}

class ErrorAddedCarState extends AddCarState {
  ErrorAddedCarState({required this.message});

  dynamic message;
}

class SuccessUploadCarPhotoState extends AddCarState {
  SuccessUploadCarPhotoState({this.response});

  final dynamic response;
}

class SuccessEditCarState extends AddCarState {
  SuccessEditCarState({required this.addedCarResponse});

  AddedCarResponse addedCarResponse;
}
