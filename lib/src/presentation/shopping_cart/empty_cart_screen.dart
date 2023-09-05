import 'package:flutter/material.dart';

class EmptyCartScreen extends StatelessWidget {
  static const routeName = '/emptycartscreen';

  const EmptyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: screenHeight / 15,
            child: Container(
              color: Colors.white.withOpacity(0.4),
              width: screenWidth,
              height: screenHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.chevron_left,
                            size: 40,
                            color: Colors.black,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight / 9,
                  ),
                  const Image(image: AssetImage('assets/empty_cart.jpeg')),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: screenHeight / 32,
                  ),
                  const Text(
                    'Scan the barcode on any product on\nthe shelf or search for it to add it to\nyour cart.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
