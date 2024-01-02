import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/domain/entity/exception.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String authTokenKey = 'auth_token';
const String userEmail = 'userEmailKey';
const String userId = 'userIdKey';

class UserAuthService {
  final Dio _dio;

  UserAuthService() : _dio = Dio() {
    // Set up Dio interceptors for handling authentication
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attempt to retrieve the authentication token from shared preferences
          SharedPreferences pref = await sl.getAsync<SharedPreferences>();

          final authToken = pref.getString(authTokenKey);

          // Include the authentication token in the request headers if available
          if (authToken != null) {
            options.headers['Authorization'] = 'Bearer $authToken';
          }

          return handler.next(options);
        },
      ),
    );
  }

  Future<String> loginUser({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        loginUserEndPoint,
        data: jsonEncode({
          'password': password,
          'mobile_no': mobileNumber,
        }),
      );
      if (response.statusCode == 200) {
        final json = response.data;
        if (json['data'] != null) {
          var id = json['data']['customer']['id'];
          var token = json['data']['token'];
          var email = json['data']['customer']['email'];
          SharedPreferences pref = await sl.getAsync<SharedPreferences>();
          await pref.setString(authTokenKey, token);
          await pref.setString(userEmail, email);
          await pref.setInt(userId, id);
        }
        return 'Login Successful';
      } else if (response.statusCode == 503) {
        throw serverErrorMsg;
      } else if (response.statusCode == 422) {
        throw wrongLoginCredential;
      }
    } on DioError catch (err) {
      if (err.type == DioErrorType.connectionError ||
          err.type == DioErrorType.sendTimeout ||
          err.type == DioErrorType.receiveTimeout ||
          err.type == DioErrorType.unknown) {
        throw noInternetExceptionMsgSubtext;
      } else if (err.type == DioErrorType.badResponse) {
        throw wrongLoginCredential;
      } else {
        throw noInternetExceptionMsgSubtext;
      }
    } on SocketException {
      throw noInternetExceptionMsgSubtext;
    }
    return '';
  }

  Future<String> registerUser({
    required String phoneNumber,
    required String password,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        registerUserEndPoint,
        data: jsonEncode({
          'mobile_no': phoneNumber,
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        final json = response.data;
        if (json['data'] != null) {
          var id = json['data']['customer']['id'];
          var token = json['data']['token'];
          var email = json['data']['customer']['email'];
          SharedPreferences pref = await sl.getAsync<SharedPreferences>();
          await pref.setString(authTokenKey, token);
          await pref.setString(userEmail, email);
          await pref.setInt(userId, id);
        }
        return 'Registration Successful';
      } else if (response.statusCode == 503) {
        throw ServerError(
          message: serverErrorMsg,
        );
      } else {
        throw wrongLoginCredential;
      }
    } on DioError catch (err) {
      if (err.type == DioErrorType.connectionError ||
          err.type == DioErrorType.sendTimeout ||
          err.type == DioErrorType.receiveTimeout ||
          err.type == DioErrorType.unknown) {
        throw noInternetExceptionMsgSubtext;
      } else if (err.type == DioErrorType.badResponse) {
        throw wrongLoginCredential;
      } else {
        throw noInternetExceptionMsgSubtext;
      }
    } on SocketException {
      throw noInternetExceptionMsgSubtext;
    }
  }

  Future<bool> addToCart({required String userId, required Order order}) async {
    try {
      final response = await _dio.post(
        addToCartEndPiont(userId),
        data: jsonEncode({
          'product_id': order.productId,
          'quantity': order.qty,
        }),
      );
      if (response.statusCode == 201) {
        // print('item added successful');
        return true;
      } else if (response.statusCode == 503) {
        throw serverErrorMsg;
      } else {
        throw response.data['message'] ?? ServerError(message: serverErrorMsg);
      }
    } on DioError catch (err) {
      if (err.type == DioErrorType.connectionError ||
          err.type == DioErrorType.sendTimeout ||
          err.type == DioErrorType.receiveTimeout ||
          err.type == DioErrorType.unknown) {
        throw noInternetExceptionMsgSubtext;
      } else if (err.type == DioErrorType.badResponse) {
        throw 'An error occured while adding item to cart';
      } else {
        throw noInternetExceptionMsgSubtext;
      }
    } on SocketException {
      throw noInternetExceptionMsgSubtext;
    }
  }

  Future<Map<String, dynamic>> getShoppingCart(String endPoint) async {
    try {
      final response = await _dio.get(endPoint);
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

  Future<void> logout() async {
    SharedPreferences pref = await sl.getAsync<SharedPreferences>();
    await pref.clear();
  }
}
