import 'package:flutter/material.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/presentation/widgets/small_button.dart';

class OTPScreen extends StatelessWidget {
  static const routeName = '/otp';
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: screenHeight / 6,
            child: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Column(
                children: [
                  const Text(
                    'Use the OTP below at the\ncheckout',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight / 22, bottom: screenHeight / 10),
                    child: Container(
                      width: screenHeight / 7,
                      height: screenHeight / 14,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor(fontColor).withOpacity(0.6)),
                    ),
                  ),
                  const SmallBtn(
                    onTap: null,
                    text: 'Done',
                    width: 140,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
