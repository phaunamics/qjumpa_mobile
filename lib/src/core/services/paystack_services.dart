import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/services/dio_client.dart';
import 'package:qjumpa/src/domain/entity/paystack_auth.dart';
import 'package:qjumpa/src/domain/entity/paystack_response.dart';
import 'package:qjumpa/src/domain/entity/transaction.dart';

class PaystackService {
  final dioClient = sl.get<DioClient>();

  // Initialize Transaction
  Future<PaystackAuthResponse> initializeTransaction({
    required String email,
    required String amount,
    String currency = "NGN",
    required String reference,
    List<String> channels = const ["card", "mobile_money"],
    Object? metadata,
  }) async {
    PaystackApiResponse response;
    try {
      response = await dioClient.postPaystack(
        url: initialTransactionUrl,
        data: jsonEncode({
          "email": email,
          "amount": amount,
          "reference": reference,
          "currency": currency,
          "metadata": metadata,
          "channels": channels,
        }),
      );

      if (response.statusCode == 200) {
        return PaystackAuthResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception(response.error.toString());
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw Exception("Error: $e");
    }
  }

  // Verify Transaction after Customer makes payment
  Future verifyTransaction(
    String reference,
    Function(Object) onSuccessfulTransaction,
    Function(Object) onFailedTransaction,
  ) async {
    PaystackApiResponse response;
    try {
      response =
          await dioClient.getPaystack(url: verifyTransactionUrl(reference));
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data["gateway_response"] == "Successful" ||
            data["gateway_response"] == "Approved") {
          // notify the user why the transaction was successful
          onSuccessfulTransaction(data);
        } else {
          // Also notify the user why the transaction was failed
          onFailedTransaction(data);
        }
      } else {
        // notify the user why the transaction was failed
        onFailedTransaction({
          "message": "Transaction failed",
        });
      }
    } on Exception catch (e) {
      onFailedTransaction({
        "message": e.toString(),
      });
    }
  }

  // Get lists of transactions
  Future<List<Transaction>> listTransactions() async {
    PaystackApiResponse response;
    try {
      response = await dioClient.getPaystack(url: listTransactionUrl);
      if (response.statusCode == 200) {
        final data = response.data as List;
        if (data.isEmpty) return [];
        return data
            .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
