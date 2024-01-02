import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/presentation/select_store/select_store_screen.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess(
      {super.key, required this.isSuccesful, required this.reference});
  final String reference;
  final bool isSuccesful;

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess>
    with TickerProviderStateMixin {
  late FlutterGifController controller1;
  @override
  void initState() {
    controller1 = FlutterGifController(
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller1.animateTo(25, duration: const Duration(milliseconds: 100));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              !widget.isSuccesful
                  ? Image.asset('assets/Payment failed.jpeg')
                  : SizedBox(
                      height: 250,
                      width: 260,
                      child: GifImage(
                        controller: controller1,
                        image: const AssetImage("assets/payment_success.gif"),
                      ),
                    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Text(
                !widget.isSuccesful
                    ? 'Your Payment was Unsuccessful'
                    : 'Payment Successful',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Text(
                widget.reference,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, SelectStoreScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                      // foregroundColor: Colors.white,
                      backgroundColor: HexColor(primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5.0),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Still need to shop? ',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          )),
    );
  }
}
