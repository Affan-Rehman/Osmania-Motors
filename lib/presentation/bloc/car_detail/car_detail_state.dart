part of 'car_detail_bloc.dart';

abstract class CarDetailState {}

class InitialCarDetailState extends CarDetailState {}

class LoadedCarDetailState extends CarDetailState {
  LoadedCarDetailState({required this.loadedDetailCar, this.latitude, this.longitude, this.marker});

  final CarDetail loadedDetailCar;
  final double? latitude;
  final double? longitude;
  final Set<Marker>? marker;
}

class ErrorCarDetailState extends CarDetailState {}
