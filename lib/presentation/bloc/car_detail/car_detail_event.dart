part of 'car_detail_bloc.dart';

abstract class CarDetailEvent {}

class CarDetailLoadEvent extends CarDetailEvent {
  CarDetailLoadEvent({required this.id, this.userId});

  final int id;
  final int? userId;
}

class DealerProfileLoadEvent extends CarDetailEvent {
  DealerProfileLoadEvent({this.dealerId});

  dynamic dealerId;
}

class AddToFavorite extends CarDetailEvent {
  AddToFavorite({this.userId, this.userToken, this.carId, this.action});

  final dynamic userId;
  final dynamic userToken;
  final dynamic carId;
  final dynamic action;
}

class RemoveFromFavorite extends CarDetailEvent {
  RemoveFromFavorite({this.userId, this.userToken, this.carId, this.action});

  final dynamic userId;
  final dynamic userToken;
  final dynamic carId;
  final dynamic action;
}
