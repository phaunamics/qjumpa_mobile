import 'package:flutter/material.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';

class BottomNavIcon extends StatelessWidget {
  final void Function()? onTap;
  final Widget widget;
  final String iconName;
  const BottomNavIcon(
      {super.key, this.onTap, required this.widget, required this.iconName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget,
          Text(
            iconName,
            style: TextStyle(
                fontSize: 12,
                color: HexColor(fontColor),
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
