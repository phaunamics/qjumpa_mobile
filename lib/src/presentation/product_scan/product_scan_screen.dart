import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/arguments.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:qjumpa/src/presentation/product_scan/bloc/barcodescanner_bloc.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/product_search_nav_bar.dart';
import 'package:qjumpa/src/presentation/widgets/custom_badge.dart';
import 'package:qjumpa/src/presentation/widgets/ios_scanner_view.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';
import 'package:qjumpa/src/presentation/widgets/search_result_card.dart';

class ProductScanScreen extends StatefulWidget {
  static const routeName = '/productscan';
  final Arguments arguments;

  const ProductScanScreen({super.key, required this.arguments});

  @override
  State<ProductScanScreen> createState() => _ProductScanScreenState();
}

class _ProductScanScreenState extends State<ProductScanScreen> {
  final _cartSharedPref = sl.get<CartSharedPreferences>();
  final getBarcodeScannerbloc = sl.get<BarcodeScannerBloc>();

  void performPlatformSpecificBarcodeScan() {
    if (Platform.isAndroid) {
      getBarcodeScannerbloc
          .add(Scan(widget.arguments.storeEntity!.id.toString()));
    } else if (Platform.isIOS) {
      Navigator.pushNamed(context, IOSScannerView.routeName);
    } else {
      // Perform default action if the platform is not recognized
      // print('Platform not recognized');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<BarcodeScannerBloc, BarcodescannerState>(
      bloc: getBarcodeScannerbloc,
      listener: (context, state) {
        if (state is BarcodescannerCompleted) {
          Navigator.pushReplacementNamed(
            context,
            ProductScanScreen.routeName,
            arguments: Arguments(
                inventory: state.inventory,
                storeEntity: widget.arguments.storeEntity),
          );
        }
      },
      child: Scaffold(
        body: productScanView(
            screenHeight: screenHeight,
            context: context,
            screenWidth: screenWidth),
        // floatingActionButton: Padding(
        //   padding: EdgeInsets.only(bottom: screenHeight / 54.0),
        //   child: BottomNavBar(
        //     pages: const [],
        //     customWidget: BottomNavIcon(
        //       iconName: 'Scan',
        //       onTap: performPlatformSpecificBarcodeScan,
        //       widget: SvgPicture.asset('assets/scan_icon.svg'),
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget productScanView(
      {required double screenHeight,
      required BuildContext context,
      required double screenWidth,
      Order? order}) {
    return Stack(
      children: [
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

                  // Container(
                  //   height: screenHeight / 9,
                  //   width: screenHeight / 2,
                  //   decoration: const BoxDecoration(
                  //     color: Colors.white,
                  //     image: DecorationImage(
                  //         image: AssetImage('assets/barcode.jpeg'),
                  //         fit: BoxFit.cover),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: screenHeight / 27,
                  // ),
                  // Center(
                  //   child: Text(
                  //     widget.arguments.inventory.sku!,
                  //     style: const TextStyle(
                  //         fontSize: 20, fontWeight: FontWeight.w600),
                  //   ),
                  // ),

                  SizedBox(
                    height: screenHeight / 36,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SearchResultCard(
                          order: widget.arguments.inventory.order,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight / 19,
                  ),
                  Center(
                    child: LargeBtn(
                      onTap: performPlatformSpecificBarcodeScan,
                      text: 'Keep scanning',
                      color: HexColor(primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 23,
                  ),
                  Center(
                    child: Text(
                      'Having trouble scanning?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: HexColor(fontColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 54,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductSearchBottomNavBar(
                                  storeEntity: widget.arguments.storeEntity!))),
                      child: Text(
                        'Manually search ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: HexColor(primaryColor),
                        ),
                      ),
                    ),
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
