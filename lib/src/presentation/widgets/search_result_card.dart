import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResultCard extends StatefulWidget {
  const SearchResultCard(
      {super.key, required this.order, this.onProductAddedToCart});

  final Order order;
  final VoidCallback? onProductAddedToCart;

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  final _prefs = sl.get<SharedPreferences>();
  final userAuthService = sl.get<UserAuthService>();

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
          height: screenHeight / 9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: HexColor(ctnColor)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 6, top: 4, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
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
                      child: GestureDetector(
                        onTap: () async {
                          final result = await userAuthService.addToCart(
                              userId: _prefs.getInt(userId).toString(),
                              order: widget.order);

                          if (widget.onProductAddedToCart != null) {
                            widget.onProductAddedToCart!();
                          }
                          result
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    backgroundColor: Colors.grey.shade300,
                                    duration: const Duration(seconds: 2),
                                    content: Text(
                                      '${widget.order.itemName} was successfully added to cart',
                                      style: TextStyle(
                                          color: HexColor(primaryColor),
                                          fontSize: 17),
                                    ),
                                  ),
                                )
                              : null;
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          child: const Center(
                            child: Icon(Icons.add_shopping_cart_rounded),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
