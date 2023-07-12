import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class MockInterceptor extends Interceptor {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    void requestHandler(String response) {
      handler.resolve(Response(
        data: json.decode(response),
        statusCode: 200,
        requestOptions: options,
      ));
    }

    switch (options.path) {
      case '/user':
        final jsonText = await rootBundle.loadString('assets/json/user.json');
        requestHandler(jsonText);
        break;

      case "/products":
        // mock usecase
        // final jsonText =
        //     await rootBundle.loadString('assets/json/product.json');
        // actual usecase
        const url = 'qjumpa-production.up.railway.app/api/products';
        requestHandler(url);
    }
  }
}
