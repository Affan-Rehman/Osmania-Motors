part of 'filter_bloc.dart';

abstract class FilterState {}

class InitialFilterState extends FilterState {}

class InitialFilterListingState extends FilterState {}

class LoadedFilterState extends FilterState {
  LoadedFilterState(this.filter, this.featuredResponse);

  List<dynamic> filter;
  FeaturedResponse featuredResponse;
}

class LoadedFilteredListingsState extends FilterState {
  LoadedFilteredListingsState(this.loadedFilteredListings);

  List<dynamic> loadedFilteredListings;
}

class ErrorFilterState extends FilterState {}

class ErrorFilterListingState extends FilterState {}
