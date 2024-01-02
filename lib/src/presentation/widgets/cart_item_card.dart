import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';

class CartItemCard extends StatefulWidget {
  const 
  CartItemCard({
    super.key,
    required this.itemName,
    required this.price,
    required this.qty,
    required this.totalAmount,
  });

  final String? itemName;
  final int totalAmount, qty,price;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Stack(children: [
      itemCardView(screenHeight, screenWidth,
          itemName: widget.itemName,
          totalAmount: widget.totalAmount,
          price: widget.price,
          qty: widget.qty),
    ]);
  }

  Column itemCardView(double screenHeight, screenWidth,
      {required String? itemName,
      required int price,
      required int qty,
      required int totalAmount}) {
    return Column(
      children: [
        Container(
          height: screenHeight <= 667 ? screenHeight / 7.3 : screenHeight / 8.6,
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
                      Text(itemName!),
                      SizedBox(
                        height: screenHeight / 92,
                      ),
                      Text(
                        NumberFormat.currency(symbol: '₦ ').format(price),
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
                                  qty += 1;
                                  // cartSharedPref.addItemToCart(
                                  //     widget.order.copyWith(qty: _qty));
                                });
                              },
                              child: Icon(Icons.add,
                                  color: HexColor(counterColor), size: 30),
                            ),
                            Text(
                              qty.toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (qty > 0) {
                                  setState(() {
                                    qty -= 1;
                                    // cartSharedPref.decreaseItemInCart(
                                    //     widget.order.copyWith(qty: _qty));
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
        totalCard(
          screenWidth: screenWidth,
          value: totalAmount,
        ),
      ],
    );
  }

  Widget totalCard({required int value, double? screenWidth}) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth! <= 375 ? 17 : 22.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            NumberFormat.currency(symbol: '₦ ').format(value),
            style: TextStyle(
                color: value == 0 ? Colors.transparent : Colors.black,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
