import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/presentation/shopping_cart/bloc/cart_bloc.dart';
import 'package:qjumpa/src/presentation/shopping_cart/cart_view.dart';

class CustomBadge extends StatelessWidget {
  final int badgeCount;
  final cartbloc = sl.get<CartBloc>();

  CustomBadge({
    super.key,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -10, end: -12),
      showBadge: true,
      ignorePointer: false,
      onTap: () {},
      badgeContent: Text(
        badgeCount.toString(),
        style: const TextStyle(fontSize: 15, color: Colors.white),
      ),
      badgeAnimation: const badges.BadgeAnimation.fade(
        animationDuration: Duration(seconds: 1),
        colorChangeAnimationDuration: Duration(seconds: 1),
        loopAnimation: false,
        curve: Curves.fastOutSlowIn,
        colorChangeAnimationCurve: Curves.easeInCubic,
      ),
      badgeStyle: badges.BadgeStyle(
        shape: badges.BadgeShape.circle,
        badgeColor: HexColor(primaryColor),
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.white, width: 2),
        elevation: 0,
      ),
      child: IconButton(
        icon: const Icon(Icons.shopping_cart_outlined),
        iconSize: 25,
        color: HexColor(primaryColor),
        onPressed: () {
          Navigator.pushNamed(context, CartView.routeName);
        },
      ),
    );
  }
}
