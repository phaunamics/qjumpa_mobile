import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/domain/entity/exception.dart';
import 'package:qjumpa/src/domain/entity/paystack_response.dart';
import 'package:qjumpa/src/domain/entity/secret_key.dart';

class DioClient {
  DioClient() {
    dio = Dio(BaseOptions(
      validateStatus: (status) {
        return true;
      },
      connectTimeout: const Duration(seconds: 3000),
      receiveTimeout: const Duration(seconds: 3000),
      followRedirects: false,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${SecretKey.publicKey}",
      },
    ));
  }

  late Dio dio;
  Future<Map<String, dynamic>> get(String endPoint) async {
    try {
      final response = await dio.get(endPoint);
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 503) {
        throw ServerError(
          message: serverErrorMsg,
        );
      } else {
        throw NoInternetException(
            message: noInternetExceptionMsg,
            subText: noInternetExceptionMsgSubtext);
      }
    } on DioError catch (err) {
      if (err.type == DioErrorType.connectionError ||
          err.type == DioErrorType.sendTimeout ||
          err.type == DioErrorType.receiveTimeout ||
          err.type == DioErrorType.unknown) {
        throw NoInternetException(
            message: noInternetExceptionMsg,
            subText: noInternetExceptionMsgSubtext);
      } else if (err.type == DioErrorType.badResponse) {
        throw ServerError(message: serverErrorMsg);
      } else {
        throw NoInternetException(
            message: noInternetExceptionMsg,
            subText: noInternetExceptionMsgSubtext);
      }
    } on SocketException {
      throw NoInternetException(
          message: noInternetExceptionMsg,
          subText: noInternetExceptionMsgSubtext);
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
