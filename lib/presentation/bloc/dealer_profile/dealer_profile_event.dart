part of 'dealer_profile_bloc.dart';

abstract class DealerProfileEvent {}

class LoadDealerProfileEvent extends DealerProfileEvent {
  LoadDealerProfileEvent({this.dealerId});

  final dynamic dealerId;
}
