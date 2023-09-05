import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/presentation/shopping_cart/cart_view.dart';
import 'package:qjumpa/src/presentation/shopping_cart/empty_cart_screen.dart';

class Cart extends StatefulWidget {
  static const routeName = '/cart';

  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _cartSharedPref = sl.get<CartSharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cartSharedPref.totalItemsInCart == 0
          ? const EmptyCartScreen()
          : CartView(),
    );
  }
}
