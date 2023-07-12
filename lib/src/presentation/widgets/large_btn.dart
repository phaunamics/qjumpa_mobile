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
    this.letterSpacing = 2,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w600,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 28),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
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
    );
  }
}
