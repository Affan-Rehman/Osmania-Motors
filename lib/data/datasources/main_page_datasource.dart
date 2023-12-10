import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:motors_app/core/dio_singleton.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/main_page/main_page.dart';

abstract class MainPageDataSource {
  Future<MainPage> getMainPage();
  Future getLatestVideos();
  Future getLatestBlog();
}

class MainPageRemoteDataSource implements MainPageDataSource {
  @override
  Future getLatestBlog() async {
    try {
      Response response = await DioSingleton().instance().get(
            'https://osmaniamotors.com/wp-json/mo/v1/posts',
          );

      return response.data;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future getLatestVideos() async {
    try {
      Response response = await DioSingleton().instance().get(
            'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCNTy7PXABVIlEbeTXeTgXZQ&maxResults=3&order=date&type=video&key=AIzaSyALiki53KbRvQ4pETr5_r9jmEOS1FgKFwA',
          );

      return response.data;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<MainPage> getMainPage() async {
    try {
      Response response =
          await DioSingleton().instance().get('$apiEndPoint/main-page');
      log('$apiEndPoint/main-page');

      return MainPage.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}
