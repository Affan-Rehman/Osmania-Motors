import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/models.dart';
import 'package:motors_app/data/repositories/car_detail_repository_impl.dart';
import 'package:motors_app/data/repositories/filter_repository_impl.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc(this.filterRepository, this.carDetailRepository)
      : super(InitialFilterState()) {
    on<LoadFilterEvent>((event, emit) async {
      emit(InitialFilterState());

      try {
        final List<dynamic> filter = await filterRepository.getFilter();
        log('filter: $filter');
        FeaturedResponse featuredResponse =
            await filterRepository.getFeaturedFilter();

        emit(LoadedFilterState(filter, featuredResponse));
      } on DioError catch (e, s) {
        logger.e('Error during with getFilter, $e, $s');
        emit(ErrorFilterState());
      }
    });

    on<AddToFilterEvent>((event, emit) async {
      emit(InitialFilterListingState());
      try {
        final List<dynamic> filter = await filterRepository.getFilteredListings(
          limit: event.limit,
          condition: event.condition,
        );

        emit(LoadedFilteredListingsState(filter));
      } on DioError catch (e, s) {
        logger.e('Error during with getFilteredListings, $e, $s');
        emit(ErrorFilterListingState());
      }
    });
  }

  final FilterRepository filterRepository;
  final CarDetailRepository carDetailRepository;
}
