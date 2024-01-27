import 'dart:async';
import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:qjumpa/src/domain/entity/shopping_cart_entity.dart';
import 'package:qjumpa/src/domain/entity/store_entity.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/domain/usecases/get_inventory_usecase.dart';
import 'package:qjumpa/src/domain/usecases/get_shopping_cart_usecase.dart';
import 'package:qjumpa/src/presentation/product_scan/bloc/barcodescanner_bloc.dart';
import 'package:qjumpa/src/presentation/product_search/bloc/product_search_bloc.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/product_search_nav_bar.dart';
import 'package:qjumpa/src/presentation/widgets/custom_badge.dart';
import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';
import 'package:qjumpa/src/presentation/widgets/ios_scanner_view.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';
import 'package:qjumpa/src/presentation/widgets/search_result_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/productsearch';
  final StoreEntity? storeEntity;

  const ProductSearchScreen({super.key, required this.storeEntity});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final _searchBarController = TextEditingController();
  late StreamController<int> _cartLengthController;
  int initialCartLength = 0;

  bool _isInitializingCartLength = true;

  final getProductSearchBloc = sl.get<ProductSearchBloc>();
  final getInventoryUseCase = sl.get<GetInventoryUseCase>();
  final getBarcodeScannerbloc = sl.get<BarcodeScannerBloc>();
  final _prefs = sl.get<SharedPreferences>();
  final getShoppingCartUsecase = sl.get<GetShoppingCartUseCase>();
  List<Inventory>? cachedInventory;
  bool isInventoryFetched = false;

  void fetchInventory() async {
    if (!isInventoryFetched) {
      cachedInventory =
          await getInventoryUseCase.call(widget.storeEntity!.id.toString());
      isInventoryFetched = true;
    }
  }

  void _performPlatformSpecificBarcodeScan() {
    if (Platform.isAndroid) {
      getBarcodeScannerbloc.add(Scan(widget.storeEntity!.id.toString()));
    } else if (Platform.isIOS) {
      Navigator.pushNamed(context, IOSScannerView.routeName);
    } else {
      // TODO: Perform default action if the platform is not recognized.
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
      initialCartLength = cartLength;
      _cartLengthController.sink.add(initialCartLength);
    } catch (error) {
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
      debugPrintStack();
    }
  }

  @override
  void initState() {
    _cartLengthController = StreamController<int>.broadcast();
    _initializeCartLength();
    fetchInventory();
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
        : BlocListener(
          bloc: getBarcodeScannerbloc,
            listener: (context, state) {
                    if (state is BarcodescannerCompleted) {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return _productScanView(
                                screenHeight: screenHeight / 100,
                                context: context,
                                screenWidth: screenWidth,
                                storeEntity: widget.storeEntity,
                                order: state.inventory.order);
                          });
                    }
                  },
                
            child: Scaffold(
              backgroundColor: Colors.white,
              body: BlocBuilder<ProductSearchBloc, ProductSearchState>(
                bloc: getProductSearchBloc,
                builder: (context, state) {
                  if (state is ProductSearchingState) {
                    return Stack(
                      children: [
                        Positioned(
                          top: screenHeight / 3,
                          left: screenHeight / 6,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Looking for a match...'),
                                SizedBox(
                                  height: screenHeight / 23,
                                ),
                                CircularProgressIndicator.adaptive(
                                  backgroundColor: HexColor(primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is ProductSearchCompletedState) {
                    if (state.inventory!.isEmpty) {
                      return buildScreen(
                        screenHeight: screenHeight,
                        context: context,
                        storeId: widget.storeEntity?.id.toString(),
                        screenWidth: screenWidth,
                        widget: SizedBox(
                          height: screenHeight / 1.8,
                          child: Center(
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/not_found.svg'),
                                const Text(
                                  'Item not found',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return buildScreen(
                        screenHeight: screenHeight,
                        context: context,
                        screenWidth: screenWidth,
                        storeId: widget.storeEntity?.id.toString(),
                        widget: SizedBox(
                          height: screenHeight / 1.8,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            itemBuilder: (_, int index) {
                              final inventory = state.inventory![index];

                              return Padding(
                                padding: EdgeInsets.fromLTRB(
                                    screenWidth <= 375 ? 1 : 3.0,
                                    10,
                                    screenWidth <= 375 ? 1 : 3.0,
                                    6),
                                child: SearchResultCard(
                                  order: inventory.order,
                                  onProductAddedToCart: () {
                                    _updateCartLength();
                                  },
                                ),
                              );
                            },
                            itemCount: state.inventory!.length,
                          ),
                        ),
                      );
                    }
                  } else if (state is ErrorState) {
                    return buildScreen(
                      screenHeight: screenHeight,
                      context: context,
                      storeId: widget.storeEntity?.id.toString(),
                      screenWidth: screenWidth,
                      widget: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight / 6.4),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight / 12,
                            ),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset('assets/network_error.jpg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return buildScreen(
                    context: context,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    storeId: widget.storeEntity?.id.toString(),
                    widget: SizedBox(
                      height: screenHeight / 1.85,
                    ),
                  );
                },
              ),
            ));
  }

  Widget buildScreen(
      {required double screenHeight,
      required BuildContext context,
      required double screenWidth,
      required String? storeId,
      required Widget widget}) {
    return Stack(
      children: [
        Positioned(
          top: screenHeight <= 667 ? screenHeight / 28 : screenHeight / 15,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight <= 667
                        ? screenHeight / 16
                        : screenHeight / 11.4,
                  ),
                  CustomTextFormField(
                      hint: 'Search by product name',
                      label: null,
                      focus: true,
                      hintFontSize: 16,
                      onChanged: (value) {
                        if (value != null) {
                          EasyDebounce.debounce('inventoorySearchDebouncer',
                              const Duration(seconds: 4), () {
                            getProductSearchBloc.add(
                              Search(value.isNotEmpty ? value : '',
                                  storeId ?? '', cachedInventory ?? []),
                            );
                          });
                        }
                      },
                      height: screenHeight / 15,
                      suffixIcon: const Icon(Icons.search),
                      controller: _searchBarController,
                      value: false),
                  widget,
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth <= 375 ? 5 : 13.0),
                    child: Row(
                      children: [
                        const Text(
                          '***Tap ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        GestureDetector(
                          onTap: _performPlatformSpecificBarcodeScan,
                          child: const Text(
                            'here ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.red,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const Text(
                          'to scan barcode instead*** ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _productScanView(
      {required double screenHeight,
      required BuildContext context,
      required double screenWidth,
      StoreEntity? storeEntity,
      Order? order}) {
    return Stack(
      children: [
        Positioned(
          top: screenHeight / 10,
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
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SearchResultCard(
                          order: order!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: LargeBtn(
                      onTap: _performPlatformSpecificBarcodeScan,
                      text: 'Keep scanning',
                      color: HexColor(primaryColor),
                    ),
                  ),
                  const SizedBox(
                    height: 38,
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
                              storeEntity: widget.storeEntity!),
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
