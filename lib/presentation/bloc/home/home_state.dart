import 'package:motors_app/data/models/main_page/main_page.dart';

import '../../../data/models/hive/brands.dart';

abstract class HomeState {}

class InitialHomeState extends HomeState {}

class LoadedHomeState extends HomeState {
  LoadedHomeState(
    this.mainPage,
    this.brands,
    this.filteredListings,
    this.latestVideos,
    // this.latestVlog,
  );
  final List<Map<String, dynamic>> filteredListings;
  final MainPage mainPage;
  final List<Brand>? brands;
  final latestVideos;
  // final latestVlog;
}

class ErrorHomeState extends HomeState {}
