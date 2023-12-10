part of 'add_car_bloc.dart';

abstract class AddCarEvent {}

class LoadAddCarParamsEvent extends AddCarEvent {
  LoadAddCarParamsEvent({required this.context});

  final BuildContext context;
}

class AddCar extends AddCarEvent {
  AddCar({required this.data});

  dynamic data;
}

class UploadPhotoEvent extends AddCarEvent {
  UploadPhotoEvent({required this.data});

  Map<String, dynamic> data;
}

class UpdateCar extends AddCarEvent {
  UpdateCar({required this.data});

  Map<String, dynamic> data;
}
