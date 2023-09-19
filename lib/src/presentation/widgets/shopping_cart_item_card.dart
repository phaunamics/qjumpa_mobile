import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.order});

  final Order order;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final cartSharedPref = sl.get<CartSharedPreferences>();

  late int _qty;

  @override
  void initState() {
    _qty = cartSharedPref.qty(widget.order.orderId);
    super.initState();
  }

  int get total {
    return widget.order.price * _qty;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Stack(children: [
      itemCardView(screenHeight, screenWidth),
    ]);
  }

  Column itemCardView(double screenHeight, double screenWidth) {
    return Column(
      children: [
        Container(
          height: screenHeight / 8.6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: HexColor(ctnColor)),
          child: Padding(
            padding: EdgeInsets.only(
                left: 15.0,
                right: 6,
                top: screenHeight / 200,
                bottom: screenHeight / 290),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.order.itemName),
                      SizedBox(
                        height: screenHeight / 92,
                      ),
                      Text(
                        NumberFormat.currency(symbol: '₦ ')
                            .format(widget.order.price),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: HexColor(counterColor)),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: screenWidth / 10,
                      height: screenHeight / 8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                    ),
                    Transform.rotate(
                      angle: 6.28,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _qty += 1;
                                  cartSharedPref.addItemToCart(
                                      widget.order.copyWith(qty: _qty));
                                });
                              },
                              child: Icon(Icons.add,
                                  color: HexColor(counterColor), size: 30),
                            ),
                            Text(
                              _qty.toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_qty > 0) {
                                  setState(() {
                                    _qty -= 1;
                                    cartSharedPref.decreaseItemInCart(
                                        widget.order.copyWith(qty: _qty));
                                  });
                                }
                              },
                              child: Icon(Icons.remove,
                                  color: HexColor(counterColor), size: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: screenHeight / 97,
        ),
        StreamBuilder<int>(
          stream: cartSharedPref.getOrderTotalStream(widget.order.orderId),
          builder: (context, snapshot) {
            return totalCard(
              value: snapshot.data ?? widget.order.price * _qty,
            );
          },
        ),
      ],
    );
  }

  Widget totalCard({required int value}) {
    return Padding(
      padding: const EdgeInsets.only(right: 22.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            NumberFormat.currency(symbol: '₦ ').format(value),
            style: TextStyle(
                color:
                    widget.order.total == 0 ? Colors.transparent : Colors.black,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
