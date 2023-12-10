import 'package:dio/dio.dart';
import 'package:motors_app/data/datasources/filter_data_source.dart';
import 'package:motors_app/data/datasources/main_page_datasource.dart';
import 'package:motors_app/data/models/hive/brands.dart';
import 'package:motors_app/data/models/main_page/main_page.dart';
import 'package:motors_app/main.dart';

abstract class MainPageRepository {
  Future<MainPage> getMainPage();
  Future<List<dynamic>> getBrands();
  Future getLatestVideos();
  Future getLatestBlog();
}

class MainPageRepositoryImpl implements MainPageRepository {
  final MainPageRemoteDataSource mainPageRemoteDataSource =
      MainPageRemoteDataSource();

  @override
  Future getLatestBlog() async {
    try {
      return await mainPageRemoteDataSource.getLatestBlog();
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future getLatestVideos() async {
    try {
      return await mainPageRemoteDataSource.getLatestVideos();
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<MainPage> getMainPage() async {
    try {
      return await mainPageRemoteDataSource.getMainPage();
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  FilterDataSource filterDataSource = FilterRemoteDataSource();

  @override
  Future<List<Brand>> getBrands() async {
    // if (brandsBox.isNotEmpty) {
    //   print('from db');
    //   return brandsBox.values.toList();
    // }

    try {
      print('getting brands ${DateTime.now()}');
      return filterDataSource
          .getFilter()
          .then((value) => value['step_one']['make'])
          .then((value) {
        List<String> sequence = [
          'toyota',
          'suzuki',
          'honda',
          'daihatsu',
          'kia',
          'nissan',
          'hyundai',
          'mitsubishi',
          'changan',
          'mercedes',
          'mg',
          'faw',
          'audi',
          'bmw',
          'prince',
          'mazda',
        ];
        print('got brands ${DateTime.now()}');
        value.sort((a, b) {
          int indexA = sequence.indexOf(a['slug']);
          int indexB = sequence.indexOf(b['slug']);
          if (indexA == -1 && indexB == -1) {
            return 0; // Both slugs are unknown, maintain the order
          } else if (indexA == -1) {
            return 1; // Unknown slug comes after known slug
          } else if (indexB == -1) {
            return -1; // Known slug comes before unknown slug
          } else {
            return indexA.compareTo(indexB); // Compare known slugs
          }
        });
        print('got brands end');
        if (brandsBox.isEmpty) {
          for (var i = 0; i < value.length; i++) {
            brandsBox
                .add(Brand(logo: value[i]['logo'], label: value[i]['label']));
          }
        }
        return brandsBox.values.toList();
      });
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}
