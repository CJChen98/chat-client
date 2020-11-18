// import 'dart:math';
import 'dart:convert';

// import 'dart:developer';
// import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

// import 'package:dio/dio.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

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
      data,
      query,
      Function(dynamic) onSuccess,
      Function(int count, int total) onSendProgress,
      Function(String error) onError}) async {
    try {
      Response response = await _dio.post(path,
          data: FormData.fromMap(data),
          queryParameters: query,
          options: Options(
              contentType: Headers.jsonContentType,
              headers: {"Authorization": token ?? ""}));
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess(response.data);
        }
      }
    } catch (e) {
      onError(e);
    }
  }

  GET<T>(String path,
      {String token,
      query,
      data,
      Function(T) onSuccess,
      Function(String error) onError}) async {
    try {
      Response response = await _dio.get(path,
          queryParameters: query,
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: {"Authorization": token ?? ""}));
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess(response.data);
        }
      }
    } catch (e) {
      onError(e);
    }
  }

  Upload(PickedFile pickedFile, Uint8List bytes,
      {String token,
      data,
      query,
      Function(dynamic) onSuccess,
      Function(int count, int total) onSendProgress,
      Function(String error) onError}) async {
    if (kIsWeb) {
      var uri = Uri.parse(GetIt.instance<AppConfig>().apiHost +
          "/upload?type=${query["type"]}&id=${query["id"] ?? ""}");
      var stream = http.ByteStream(pickedFile.openRead());
      var multipartFile = http.MultipartFile('img', stream, bytes.length,
          filename: "image.png", contentType: MediaType('image', 'png'));
      var request = http.MultipartRequest("POST", uri);
      request.files.add(multipartFile);
      request.headers["content-type"] = "application/json; charset=utf-8";
      request.headers["Authorization"] = GetIt.instance<AppConfig>().token;
      var response = await request.send();
      print(response.statusCode);
      await response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        onSuccess(json.decode(value));
      });
    } else {
      POST("/upload",
          token: token,
          query: query,
          data: {
            "img": await MultipartFile.fromFile(pickedFile.path,
                filename: "image.png", contentType: MediaType('image', 'png'))
          },
          onSuccess: onSuccess,
          onError: onError);
    }
  }
}
