part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {
  LoadProfileEvent(this.id);

  final dynamic id;
}

class DeleteCarEvent extends ProfileEvent {
  DeleteCarEvent({this.data});

  final dynamic data;
}

class RemoveFavouriteCarEvent extends ProfileEvent {
  RemoveFavouriteCarEvent({this.userId, this.userToken, this.carId});

  final dynamic userId;
  final dynamic userToken;
  final dynamic carId;
}

class GetEditCar extends ProfileEvent {
  GetEditCar({this.carId, required this.context});

  final dynamic carId;
  final BuildContext context;
}
