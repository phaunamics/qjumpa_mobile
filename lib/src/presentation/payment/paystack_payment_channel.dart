import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/core/utils/uuid_generator.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/enums.dart';
import 'package:qjumpa/src/domain/entity/secret_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef PaymentCallback = void Function(bool status, String reference);

class PaystackPaymentChannel extends StatefulWidget {
  // final void Function()? onTap;
  final int? grandTotal;
  final PaymentCallback callback;
  const PaystackPaymentChannel(
      {super.key, required this.grandTotal, required this.callback});

  @override
  State<PaystackPaymentChannel> createState() => _PaystackPaymentChannelState();
}

class _PaystackPaymentChannelState extends State<PaystackPaymentChannel> {
  final cartSharedPref = sl.get<CartSharedPreferences>();
  final _prefs = sl.get<SharedPreferences>();
  final plugin = PaystackPlugin();
  String successMessage = '';

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: SecretKey.publicKey);
  }

  checkout() async {
    int grandTotal = (widget.grandTotal!.round()) * 100;
    Charge charge = Charge()
      ..amount = grandTotal
      ..reference = UUIDGenerator.uniqueRefenece(4)
      ..email = _prefs.getString(userEmail)
      ..subAccount = ''
      ..bearer = Bearer.SubAccount
      ..transactionCharge = 99.7.round()
      ..currency = "NGN";
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status == true) {
      widget.callback(true, response.reference as String);
    } else {
      widget.callback(false, response.reference as String);
      // Handle payment failure
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight / 3.2,
      child: Column(
        children: [
          SizedBox(
            height: screenHeight / 23,
          ),
          Text(
            "Choose a payment method",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: screenHeight / 12),
          channelWidget(context, Channel.card, HexColor(primaryColor)),
        ],
      ),
    );
  }

  InkWell channelWidget(
    BuildContext context,
    Channel channel,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        checkout();
      },
      child: SizedBox(
        width: 300,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.add_card_outlined,
                  color: Colors.white,
                ),
                Text(
                  channel.name.split("_").join(" ").toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
