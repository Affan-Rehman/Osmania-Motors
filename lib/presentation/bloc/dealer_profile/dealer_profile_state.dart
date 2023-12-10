part of 'dealer_profile_bloc.dart';

abstract class DealerProfileState {}

class InitialDealerProfileState extends DealerProfileState {}

class LoadedDealerProfileState extends DealerProfileState {
  LoadedDealerProfileState(this.dealerResponse);

  final DealerResponse dealerResponse;
}

class ErrorDealerProfileState extends DealerProfileState {}
