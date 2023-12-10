part of 'filter_result_bloc.dart';

abstract class FilterState {}

class InitialFilterListingState extends FilterState {
  InitialFilterListingState();
}

class LoadedFilteredListingsState extends FilterState {
  LoadedFilteredListingsState(
    this.loadedFilteredListings, {
    this.groupValue,
    this.maxPrice,
    this.locations,
    this.models,
    this.currentCity,
  });
  double? maxPrice;
  int? groupValue;
  List<dynamic> loadedFilteredListings;
  List<dynamic>? locations;
  List<dynamic>? models;
  String? currentCity;
}

class ErrorFilterListingState extends FilterState {}

class EmptyFilteredListingState extends FilterState {}
