import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/arguments.dart';
import 'package:qjumpa/src/domain/entity/store_entity.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/domain/usecases/get_inventory_usecase.dart';
import 'package:qjumpa/src/presentation/product_scan/bloc/barcodescanner_bloc.dart';
import 'package:qjumpa/src/presentation/product_scan/product_scan_screen.dart';
import 'package:qjumpa/src/presentation/product_search/bloc/product_search_bloc.dart';
import 'package:qjumpa/src/presentation/widgets/custom_badge.dart';
import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';
import 'package:qjumpa/src/presentation/widgets/ios_scanner_view.dart';
import 'package:qjumpa/src/presentation/widgets/search_result_card.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/productsearch';
  final StoreEntity? storeEntity;

  const ProductSearchScreen({super.key, required this.storeEntity});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final _searchBarController = TextEditingController();
  final getProductSearchBloc = sl.get<ProductSearchBloc>();
  final getInventoryUseCase = sl.get<GetInventoryUseCase>();
  final _cartSharedPref = sl.get<CartSharedPreferences>();
  final getBarcodeScannerbloc = sl.get<BarcodeScannerBloc>();

  List<Inventory>? cachedInventory;
  bool isInventoryFetched = false;

  void fetchInventory() async {
    if (!isInventoryFetched) {
      cachedInventory =
          await getInventoryUseCase.call(widget.storeEntity!.id.toString());
      isInventoryFetched = true;
    }
  }

  void performPlatformSpecificBarcodeScan() {
    if (Platform.isAndroid) {
      getBarcodeScannerbloc.add(Scan(widget.storeEntity!.id.toString()));
    } else if (Platform.isIOS) {
      Navigator.pushNamed(context, IOSScannerView.routeName);
    } else {
      // Perform default action if the platform is not recognized
      // print('Platform not recognized');
    }
  }

  @override
  void initState() {
    fetchInventory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<BarcodeScannerBloc, BarcodescannerState>(
      bloc: getBarcodeScannerbloc,
      listener: (context, state) {
        if (state is BarcodescannerCompleted) {
          Navigator.pushNamed(
            context,
            ProductScanScreen.routeName,
            arguments: Arguments(
                inventory: state.inventory, storeEntity: widget.storeEntity),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<ProductSearchBloc, ProductSearchState>(
          bloc: getProductSearchBloc,
          builder: (context, state) {
            if (state is ProductSearchingState) {
              return Stack(
                children: [
                  Positioned(
                    top: screenHeight / 5,
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
                          CircularProgressIndicator(
                            color: HexColor(primaryColor),
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
                                fontSize: 16, fontWeight: FontWeight.w700),
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
                          padding: const EdgeInsets.fromLTRB(6.0, 10, 6, 6),
                          child: SearchResultCard(
                            order: inventory.order,
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child:
                              Image.asset('assets/No Internet Connection.png'),
                        ),
                      ],
                    ),
                  ));
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
        // bottomNavigationBar: BottomNavBar(
        //   pages: [
        //     buildScreen(
        //         screenHeight: screenHeight,
        //         context: context,
        //         screenWidth: screenWidth,
        //         storeId: widget.storeEntity?.id.toString(),
        //         widget: const SizedBox()),
        //     const ShoppingList()
        //   ],
        //   currentIndex: 0,
        //   customWidget: SvgPicture.asset(
        //     'assets/shop_icon.svg',
        //   ),
        // ),
      ),
    );
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
                    height: screenHeight / 11.4,
                  ),
                  CustomTextFormField(
                      hint: 'Search by product name',
                      label: '',
                      focus: true,
                      hintFontSize: 16,
                      onChanged: (value) {
                        if (value != null) {
                          getProductSearchBloc.add(Search(
                              value.isNotEmpty ? value : '',
                              storeId ?? '',
                              cachedInventory ?? []));
                        }
                      },
                      height: screenHeight / 15,
                      suffixIcon: const Icon(Icons.search),
                      controller: _searchBarController,
                      value: false),
                  widget,
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
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
                          onTap: performPlatformSpecificBarcodeScan,
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
}
