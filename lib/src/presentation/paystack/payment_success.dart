import 'package:flutter/material.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/presentation/shopping_list/shopping_list.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key, required this.successMessage});
  final String successMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      const DoodleBackground(),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.network(
                "https://res.cloudinary.com/iamvictorsam/image/upload/v1671834054/Capture_inlcff.png",
                height: MediaQuery.of(context).size.height * 0.4, //40%
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Text(successMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShoppingList()));
                  },
                  style: ElevatedButton.styleFrom(
                      // foregroundColor: Colors.white,
                      backgroundColor: HexColor(ctnColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5.0),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Back to Home Screen',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          )),
    ]));
  }
}
