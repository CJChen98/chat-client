import 'package:dio/dio.dart';

class MyHttpClient {
  static Dio _client;
  static Dio getHttpClient() {
    if (_client == null) {
      _client = Dio();
      _client.options..baseUrl = "http://127.0.0.1/api/v1/";
      _client.interceptors
        ..add(LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ));
    }
    return _client;
  }

  // ignore: non_constant_identifier_names
  static Future<Response> POST(String path, data) async {
    Response response = await getHttpClient().post(path,
        data: data, options: Options(contentType: Headers.formUrlEncodedContentType));
    return response;
  }
}
