import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/data/preferences/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';

class CustomAnimatedContainer extends StatefulWidget {
  final Order order;
  const CustomAnimatedContainer({super.key, required this.order});

  @override
  _CustomAnimatedContainerState createState() =>
      _CustomAnimatedContainerState();
}

class _CustomAnimatedContainerState extends State<CustomAnimatedContainer> {
  double _containerHeight = 100.0;
  bool _isExpanded = false;
  final cartSharedPref = sl.get<CartSharedPreferences>();

  void _toggleContainerHeight() {
    setState(() {
      _isExpanded = !_isExpanded;
      _containerHeight = _isExpanded ? 200.0 : 100.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: _toggleContainerHeight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _containerHeight,
        width: 200.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: HexColor(ctnColor)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenheight / 78,
                ),
                Text(
                  widget.order.itemName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: screenheight / 45,
                ),
                Text(
                  NumberFormat.currency(symbol: '₦ ')
                      .format(widget.order.price),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: screenheight / 30,
                ),
                if (_isExpanded)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        cartSharedPref.addItemToCart(widget.order);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12))),
                            backgroundColor: Colors.grey.shade300,
                            content: Text(
                              '${widget.order.itemName} was successfully added to cart',
                              style: TextStyle(
                                  color: HexColor(primaryColor), fontSize: 17),
                            ),
                          ),
                        );
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      child: Text(
                        'Add To Cart',
                        style: TextStyle(color: HexColor(primaryColor)),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
