import 'package:flutter/material.dart';

class LargeBtn extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final double letterSpacing;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  const LargeBtn({
    super.key,
    required this.onTap,
    required this.text,
    this.letterSpacing = 0,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 175,
        margin: EdgeInsets.symmetric(horizontal: size.height / 20.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height / 71),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: fontWeight,
                letterSpacing: letterSpacing,
                fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
