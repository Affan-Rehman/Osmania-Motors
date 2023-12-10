// import 'package:dio/dio.dart';

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/utils/location_permission.dart';
import 'package:motors_app/data/models/hive/brands.dart';
import 'package:motors_app/data/models/main_page/main_page.dart';
import 'package:motors_app/data/repositories/filter_repository_impl.dart';
import 'package:motors_app/data/repositories/main_page_repository_impl.dart';
import 'package:motors_app/presentation/bloc/home/home_event.dart';
import 'package:motors_app/presentation/bloc/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.mainPageRepository, this.filterRepository)
      : super(InitialHomeState()) {
    on<HomeLoadEvent>((event, emit) async {
      emit(InitialHomeState());
      LocationPermissionImpl locationPermissionImpl = LocationPermissionImpl();
      String? city = await locationPermissionImpl.getCurrentCity();
      log('city: $city');
      final List<Brand>? brands;
      final latestVideos = await mainPageRepository.getLatestVideos();
      // final latestVlogs = await mainPageRepository.getLatestBlog();
      // // get latestVlog from latestVlogs and filter by date
      // final List<dynamic> latestVlog = latestVlogs
      //     .cast<Map<String, dynamic>>()
      //     .where(
      //       (element) => DateTime.parse(element['post_date'])
      //           .isAfter(DateTime.now().subtract(Duration(days: 7))),
      //     )
      //     .toList();
      // // log latest vlog in latestVlog list
      // log('latest blog' + latestVlog.last.toString());

      // log('latestVlogs: $latestVlogs');
      final results = await Future.wait([
        mainPageRepository.getMainPage(),
        mainPageRepository.getBrands(),
      ]);

      final mainPage = results[0] as MainPage;
      brands = results[1] as List<Brand>;

      // MainPage mainPage = await mainPageRepository.getMainPage();

      // final List<dynamic>? filter =
      //     await filterRepository.getFilteredListings();
      // change filter to list<Map<String, dynamic>> here
      // List<Map<String, dynamic>>? filters =
      //     filter![0]['listings'].cast<Map<String, dynamic>>();
      // log(filters![0]['listings'].toString());
      city = preferences.getString('city');
      // List<Map<String, dynamic>> listings = filters!;
      List<Map<String, dynamic>> filteredListings = [];
      // for (Map<String, dynamic> listing in listings) {
      //   if (listing['grid'] != null &&
      //       listing['grid']['infoDesc'] != null &&
      //       listing['grid']['infoDesc']
      //           .toString()
      //           .toLowerCase()
      //           .contains(city?.toLowerCase() ?? '')) {
      //     filteredListings.add(listing);
      //   }
      // }
      // limit filteredListings to 5
      // if (filteredListings.length > 5)
      //   filteredListings = filteredListings.sublist(0, 5);
      // filters[0]['listings'] = filteredListings;
      // log('filters: ${filters[0]['listings']}');
      // brands = await mainPageRepository.getBrands();

      // log('mainPage.recent: ${mainPage.recent.map((e) => e!.list).toList()}');
      // limit recent to 10
      if (mainPage.recent.length > 5)
        mainPage.recent = mainPage.recent.sublist(0, 5);
      // log('mainPage.featured: ${mainPage.featured.map((e) => e.toJson()).toList()}');
      viewType = mainPage.viewType;

      emit(
        LoadedHomeState(
          mainPage,
          brands,
          filteredListings,
          latestVideos,
          // latestVlog.last,
        ),
      );
    });
  }

  final MainPageRepository mainPageRepository;
  final FilterRepository filterRepository;
}
