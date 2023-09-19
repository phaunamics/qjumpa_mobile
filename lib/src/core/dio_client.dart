import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:qjumpa/src/domain/entity/exception.dart';
import 'package:qjumpa/src/domain/entity/paystack_response.dart';
import 'package:qjumpa/src/domain/entity/secret_key.dart';

class DioClient {
  DioClient() {
    dio = Dio(BaseOptions(
      validateStatus: (status) {
        return true;
      },
      followRedirects: false,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${SecretKey.publicKey}",
      },
    ));
  }

  late Dio dio;

  // initDio() {
  //   dio.interceptors.add(MockInterceptor());
  // }

  // Future<Map<String, dynamic>> get(String endPoint) async {
  //   try {
  //     final response = await dio.get(endPoint);
  //     // print('status code is ${response.statusCode}');
  //     return response.data;
  //   } on DioError catch (err) {
  //     throw ('The error is $err');
  //   }
  // }

  Future<Map<String, dynamic>> get(String endPoint) async {
    try {
      final response = await dio.get(endPoint);
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 503) {
        throw ServerError(
          message: 'Server returned error status: ${response.statusCode}',
        );
      } else {
        throw NoInternetException(message: 'No internet connection');
      }
    } on DioError catch (err) {
      if (err.type == DioErrorType.connectionError ||
          err.type == DioErrorType.sendTimeout ||
          err.type == DioErrorType.receiveTimeout) {
        throw NoInternetException(message: 'No internet connection');
      } else {
        throw ServerError(message: 'An error occurred: ${err.message}');
      }
    }
  }

  Future<PaystackApiResponse> postPaystack({
    required String url,
    FormData? formData,
    String? data,
  }) async {
    // _dio.options = options;
    Response response;
    final PaystackApiResponse apiResponse = PaystackApiResponse();
    try {
      response = await dio.post(
        url,
        data: formData ?? data,
      );
      final raw = jsonDecode(jsonEncode(response.data));
      apiResponse.data = raw["data"] ?? raw;
      apiResponse.statusCode = response.statusCode;
    } catch (e) {
      if (e is DioError) {
        apiResponse.error = {"message": e.response?.data};
        apiResponse.statusCode = e.response?.statusCode;
      } else {
        apiResponse.error = {"message": "Unknown error occurred!"};
        apiResponse.statusCode = null;
      }
    }
    return apiResponse;
  }

  Future<PaystackApiResponse> putPayStack({
    required String url,
    FormData? formData,
    String? data,
  }) async {
    // _dio.options = options;
    Response response;
    final PaystackApiResponse apiResponse = PaystackApiResponse();
    try {
      response = await dio.put(
        url,
        data: formData ?? data,
      );
      final raw = jsonDecode(jsonEncode(response.data));
      apiResponse.data = raw["data"] ?? raw;
      apiResponse.statusCode = response.statusCode;
    } catch (e) {
      if (e is DioError) {
        apiResponse.error = {"message": e.response?.data};
        apiResponse.statusCode = e.response?.statusCode;
      } else {
        apiResponse.error = {"message": "Unknown error occurred!"};
        apiResponse.statusCode = null;
      }
    }
    return apiResponse;
  }

  Future<PaystackApiResponse> getPaystack({
    required String url,
    Map<String, dynamic>? mapValue = const <String, dynamic>{},
  }) async {
    // _dio.options = options;
    Response response;
    final PaystackApiResponse apiResponse = PaystackApiResponse();
    try {
      response = await dio.get(
        url,
        queryParameters: mapValue,
      );
      final raw = jsonDecode(jsonEncode(response.data));
      if (raw is List) {
        apiResponse.data = raw;
      } else {
        apiResponse.data = raw["data"] ?? raw;
      }
      apiResponse.statusCode = response.statusCode;
    } catch (e) {
      if (e is DioError) {
        apiResponse.error = {"message": e.response?.data};
        apiResponse.statusCode = e.response?.statusCode;
      } else {
        apiResponse.error = {"message": "Unknown error occurred!"};
        apiResponse.statusCode = null;
      }
    }
    return apiResponse;
  }
}
