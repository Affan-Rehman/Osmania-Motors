import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class DioSingleton {
  factory DioSingleton() {
    DioSingleton._dio ??= Dio();
    DioSingleton._dio.options.headers[Headers.acceptHeader] = 'application/json';
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return _instance;
  }

  DioSingleton._internal();

  static final DioSingleton _instance = DioSingleton._internal();
  static var _dio;

  Dio instance() {
    return _dio;
  }
}
