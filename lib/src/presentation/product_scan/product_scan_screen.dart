import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/arguments.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:qjumpa/src/domain/entity/shopping_cart_entity.dart';
import 'package:qjumpa/src/domain/usecases/get_shopping_cart_usecase.dart';
import 'package:qjumpa/src/presentation/product_scan/bloc/barcodescanner_bloc.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/product_search_nav_bar.dart';
import 'package:qjumpa/src/presentation/widgets/custom_badge.dart';
import 'package:qjumpa/src/presentation/widgets/ios_scanner_view.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';
import 'package:qjumpa/src/presentation/widgets/search_result_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductScanScreen extends StatefulWidget {
  static const routeName = '/productscan';
  final Arguments arguments;

  const ProductScanScreen({super.key, required this.arguments});

  @override
  State<ProductScanScreen> createState() => _ProductScanScreenState();
}

class _ProductScanScreenState extends State<ProductScanScreen> {
  final getShoppingCartUsecase = sl.get<GetShoppingCartUseCase>();
  final _prefs = sl.get<SharedPreferences>();
  final getBarcodeScannerbloc = sl.get<BarcodeScannerBloc>();
  late StreamController<int> _cartLengthController;
  int initialCartLength = 0;
  bool _isInitializingCartLength = true;

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

  Future<int> _fetchCartLength() async {
    final ShoppingCartEntity? shoppingCart =
        await getShoppingCartUsecase.call(_prefs.getInt(userId).toString());
    // return shoppingCart!.data!.cartItems!.length;
    if (shoppingCart != null &&
        shoppingCart.data != null &&
        shoppingCart.data!.cartItems != null) {
      return shoppingCart.data!.cartItems!.length;
    } else {
      return 0;
    }
  }

  Future<void> _updateCartLength() async {
    try {
      final cartLength = await _fetchCartLength();
      // print("cart length is $cartLength");
      initialCartLength = cartLength;
      _cartLengthController.sink.add(initialCartLength);
    } catch (error) {
      // print('Error fetching initial cart length: $error');
      _cartLengthController.sink.add(
          initialCartLength); // Fallback to 0 or handle the error as required
    }
  }

  Future<void> _initializeCartLength() async {
    try {
      int length = await _fetchCartLength();
      setState(() {
        initialCartLength = length;
        _isInitializingCartLength = false;
      });
      _cartLengthController.sink
          .add(initialCartLength); // Add the length to your stream
    } catch (error) {
      print('Error initializing cart length: $error');
      // Handle error as per your requirements
    }
  }

  @override
  void initState() {
    _cartLengthController = StreamController<int>.broadcast();
    _initializeCartLength();
    super.initState();
  }

  @override
  void dispose() {
    _cartLengthController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return _isInitializingCartLength
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: HexColor(primaryColor),
              ),
            ),
          )
        : BlocListener<BarcodeScannerBloc, BarcodescannerState>(
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
                        stream: _cartLengthController.stream,
                        initialData: initialCartLength,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CustomBadge(
                                badgeCount: 0 // Use the snapshot data
                                );
                          }
                          return CustomBadge(
                            badgeCount: snapshot.data!, // Use the snapshot data
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight / 36,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SearchResultCard(
                          order: widget.arguments.inventory.order,
                          onProductAddedToCart: () {
                            _updateCartLength();
                          },
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
                              storeEntity: widget.arguments.storeEntity!),
                        ),
                      ),
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
