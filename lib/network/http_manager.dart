import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:get_it/get_it.dart';

class HttpManager {
  Dio _dio;

  HttpManager() {
    this._dio = Dio();
    _dio.options..baseUrl = GetIt.instance<AppConfig>().apiHost;
    _dio.interceptors
      ..add(LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
  }

  // ignore: non_constant_identifier_names
  POST<T>(String path,
      {String token,
        Map<String, dynamic> data,
        Function(T) onSuccess,
        Function(String error) onError}) async {
    try {
      Response response = await _dio.post(path,
          data: data,
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: {"Authorization": token??""}));
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess(response.data);
        }
      } else {
        throw Exception('errorMsg: ${response.data}');
      }
    } catch (e) {
      log(e);
      onError(e);
    }
  }
  GET<T>(String path,
      {String token,
        parameters,
        data,
        Function(T) onSuccess,
        Function(String error) onError}) async {
    try {
      Response response = await _dio.get(path,
          queryParameters: parameters,
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: {"Authorization": token??""}));
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess(response.data);
        }
      } else {
        throw Exception('errorMsg: ${response.data}');
      }
    } catch (e) {
      log(e);
      onError(e);
    }
  }
}
