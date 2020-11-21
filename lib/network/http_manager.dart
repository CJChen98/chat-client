// import 'dart:math';
import 'dart:convert';

// import 'dart:developer';
// import 'dart:html' as html;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// import 'package:dio/dio.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/util/image/image_util.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
      Function(dynamic) onError}) async {
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

  GET(String path,
      {String token,
      query,
      data,
      Function(dynamic) onSuccess,
      Function(dynamic) onError}) async {
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

  Upload(Uint8List byte,
      {PickedFile pickedFile,
      String token,
      data,
      query,
      Function(dynamic) onSuccess,
      Function(int count, int total) onSendProgress,
      Function(dynamic) onError}) async {

    if (kIsWeb) {
      var bytes = await compressImageByDart(byte);
      try {
        var uri = Uri.parse(GetIt.instance<AppConfig>().apiHost +
            "/upload?type=${query["type"]}&id=${query["id"] ?? ""}");
        // var stream = http.ByteStream(pickedFile.openRead());
        var multipartFile = http.MultipartFile.fromBytes('img', bytes,
            filename: "image.png", contentType: MediaType('image', 'png'));
        var request = http.MultipartRequest("POST", uri);
        request.files.add(multipartFile);
        request.headers["content-type"] = "application/json; charset=utf-8";
        request.headers["Authorization"] = token;
        var response = await request.send();
        print(response.statusCode);
        await response.stream.transform(utf8.decoder).listen((value) {
          print(value);
          onSuccess(json.decode(value));
        });
      } catch (e) {
        if (onError != null) onError(e);
      }
    } else {
      var bytes = await compressImageByNative(byte,pickedFile);
      await POST("/upload",
          token: token,
          query: query,
          data: {
            "img": await MultipartFile.fromBytes(bytes,
                filename: "image.png", contentType: MediaType('image', 'png'))
          },
          onSuccess: onSuccess,
          onError: onError);
    }
  }
}
