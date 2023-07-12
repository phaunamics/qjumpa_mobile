import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/data/preferences/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/presentation/product_search/product_search_screen.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/bottom_nav_bar.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav_icon.dart';
import 'package:qjumpa/src/presentation/widgets/custom_badge.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';
import 'package:qjumpa/src/presentation/widgets/inventory_animated_container.dart';

class ProductScanScreen extends StatefulWidget {
  static const routeName = '/productscan';
  final Inventory inventory;

  const ProductScanScreen({super.key, required this.inventory});

  @override
  State<ProductScanScreen> createState() => _ProductScanScreenState();
}

class _ProductScanScreenState extends State<ProductScanScreen> {
  final _cartSharedPref = sl.get<CartSharedPreferences>();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: productScanView(
          screenHeight: screenHeight,
          context: context,
          screenWidth: screenWidth),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: screenHeight / 54.0),
        child: BottomNavBar(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          widget: BottomNavIcon(
            value: 'Scan',
            onTap: null,
            widget: SvgPicture.asset('assets/scan_icon.svg'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Stack productScanView(
      {required double screenHeight,
      required BuildContext context,
      required double screenWidth,
      Order? order}) {
    return Stack(
      children: [
        const DoodleBackground(),
        Positioned(
          top: screenHeight / 15,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StreamBuilder<int>(
                        stream: _cartSharedPref.cartCountStream,
                        initialData: _cartSharedPref.totalItemsInCart,
                        builder: (context, snapshot) {
                          return CustomBadge(
                            badgeCount: snapshot.data ?? 0,
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight / 20,
                  ),
                  Container(
                    height: screenHeight / 9,
                    width: screenHeight / 2,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage('assets/barcode.jpeg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 27,
                  ),
                  Center(
                    child: Text(
                      widget.inventory.sku!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 76,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomAnimatedContainer(
                          order: widget.inventory.order,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight / 34,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Barcode issues?',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, ProductSearchScreen.routeName),
                        child: const Text(
                          'Add Item',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
