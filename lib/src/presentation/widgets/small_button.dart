import 'package:flutter/material.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';

class SmallBtn extends StatelessWidget {
  final String text;
  final double width;
  final double? fontSize;
  final FontWeight? fontWeight;
  final void Function()? onTap;
  const SmallBtn({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 110,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 28),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: HexColor(primaryColor),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontWeight: fontWeight,
              letterSpacing: 2,
              fontSize: fontSize),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
