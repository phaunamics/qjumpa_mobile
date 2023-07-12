import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/firebase_auth.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/core/uuid_generator.dart';
import 'package:qjumpa/src/data/preferences/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/enums.dart';
import 'package:qjumpa/src/domain/entity/secret_key.dart';
import 'package:qjumpa/src/presentation/paystack/payment_success.dart';

// final _stateChannel =
//     StateProvider.autoDispose<Channel>((ref) => Channel.mobile_money);

class PaymentMethod extends StatefulWidget {
  // final void Function()? onTap;
  const PaymentMethod({
    super.key,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final cartSharedPref = sl.get<CartSharedPreferences>();
  final auth = sl.get<Auth>();
  final plugin = PaystackPlugin();
  String successMessage = '';

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: SecretKey.publicKey);
  }

  checkout() async {
    int price = int.parse(cartSharedPref.subTotal.toString()) * 100;
    Charge charge = Charge()
      ..amount = price
      ..reference = UUIDGenerator.uniqueRefenece(12)
      ..email = auth.currentUser?.email
      ..currency = "NGN";
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    print(response);

    if (response.status == true) {
      print(response);
      successMessage = 'Payment was successful. Ref: ${response.reference}';

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PaymentSuccess(successMessage: successMessage)),
          ModalRoute.withName('/'));
    } else {
      print(response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // final channel = ref.watch(_stateChannel);
    return SizedBox(
      height: screenHeight / 5.3,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "Choose a payment method",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: screenHeight / 26),
          channelWidget(context, Channel.card, HexColor(ctnColor)),
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
      //
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PaymentScreen(
      //       reference: UUIDGenerator.uniqueRefenece(12),
      //       currency: 'NGN',
      //       email: 'email@yahoo.com',
      //       amount: (cartSharedPref.subTotal * 100).toString(),
      //       onCompletedTransaction: (value) {
      //         print("completed transaction ${value.toString()}");
      //       },
      //       onFailedTransaction: (value) {
      //         print("completed transaction ${value.toString()}");
      //       },
      //     ),
      //   ),
      child: SizedBox(
        width: 300,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.add_card_outlined),
                Text(
                  channel.name.split("_").join(" ").toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
