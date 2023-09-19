import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/firebase_auth.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/core/usecase.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/exception.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:qjumpa/src/domain/entity/store_entity.dart';
import 'package:qjumpa/src/domain/usecases/get_store_usecase.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/product_scan/bloc/barcodescanner_bloc.dart';
import 'package:qjumpa/src/presentation/product_search/product_search_screen_.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/product_search_nav_bar.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/shopping_list_nav_bar.dart';
import 'package:qjumpa/src/presentation/widgets/custom_badge.dart';
import 'package:qjumpa/src/presentation/widgets/error_widget.dart';
import 'package:qjumpa/src/presentation/widgets/ios_scanner_view.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';
import 'package:qjumpa/src/presentation/widgets/search_result_card.dart';

class SelectStoreScreen extends StatefulWidget {
  static const routeName = '/storesearch';
  const SelectStoreScreen({super.key});

  @override
  State<SelectStoreScreen> createState() => _SelectStoreScreenState();
}

class _SelectStoreScreenState extends State<SelectStoreScreen> {
  StoreEntity? _dropdownValue;
  final getBarcodeScannerbloc = sl.get<BarcodeScannerBloc>();
  final getstore = sl.get<GetStoreUseCase>();
  final _cartSharedPref = sl.get<CartSharedPreferences>();
  
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void performPlatformSpecificBarcodeScan() {
    if (Platform.isAndroid) {
      getBarcodeScannerbloc.add(
        Scan(
          _dropdownValue!.id.toString(),
        ),
      );
    } else if (Platform.isIOS) {
      Navigator.pushNamed(context, IOSScannerView.routeName);
    } else {
      // Perform default action if the platform is not recognized
      // print('Platform not recognized');
    }
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // getstore.call(NoParams());
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 10));

    await getstore.call(NoParams());
    if (mounted) {
      setState(() {});
    }
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<BarcodeScannerBloc, BarcodescannerState>(
      bloc: getBarcodeScannerbloc,
      listener: (context, state) {
        if (state is BarcodescannerCompleted) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return productScanView(
                    screenHeight: screenHeight / 100,
                    context: context,
                    screenWidth: screenWidth,
                    storeEntity: _dropdownValue,
                    order: state.inventory.order);
              });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(
            waterDropColor: HexColor(primaryColor),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          child: BlocBuilder<BarcodeScannerBloc, BarcodescannerState>(
            bloc: getBarcodeScannerbloc,
            builder: (context, state) {
              if (state is BarcodescannerInitial) {
                initialBuild(screenHeight, context);
              }
              if (state is BarcodescannerCompleted) {
                productScanView(
                    screenHeight: screenHeight / 100,
                    context: context,
                    screenWidth: screenWidth,
                    storeEntity: _dropdownValue,
                    order: state.inventory.order);
              }
              return initialBuild(screenHeight, context);
            },
          ),
        ),
      ),
    );
  }

  Stack initialBuild(double screenHeight, BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          //ui implementation for dropdown menu showcasing different stores
          child: FutureBuilder(
            future: getstore.call(NoParams()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButtonFormField<StoreEntity>(
                        value: _dropdownValue,
                        hint: const Text('What supermarket are you in?'),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 0.9),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 0.9),
                          ),
                        ),
                        items: (snapshot.data as List<StoreEntity>)
                            .map<DropdownMenuItem<StoreEntity>>((store) {
                          return DropdownMenuItem<StoreEntity>(
                            value: store,
                            child: Text(store.businessName!),
                          );
                        }).toList(),
                        onChanged: (StoreEntity? newValue) {
                          setState(() {
                            _dropdownValue = newValue;
                          });
                        },
                      ),
                      SizedBox(
                        height: screenHeight / 27,
                      ),
                      GestureDetector(
                        onTap: () {
                          shoppingOptionPopUp(context, screenHeight).show();
                        },
                        child: Container(
                          height: 52,
                          width: 175,
                          padding: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _dropdownValue == null
                                ? Colors.grey
                                : HexColor(primaryColor),
                          ),
                          child: const Text(
                            'Start Shopping',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not shopping now? Make a",
                            style: TextStyle(
                                fontSize: 15, color: HexColor(fontColor)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ShoppingListNavBar()));
                            },
                            child: const SizedBox(
                              child: Text(
                                " shopping list >>",
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                if (snapshot.error is ServerError) {
                  return const CustomErrorWidget(
                    imageUrl: 'assets/server_error.png',
                    text:
                        'Oops... We hoped you would never get to see this page and we are working hard to make sure you never see it again.',
                  );
                } else if (snapshot.error is NoInternetException) {
                  return const CustomErrorWidget(
                    imageUrl: 'assets/network_error.jpg',
                    text: 'In this case, it’s not us, it’s you 👀',
                    subText:
                        'Please check your internet connection and try again.',
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Getting List of Stores...'),
                      SizedBox(
                        height: screenHeight / 34,
                      ),
                      CircularProgressIndicator(
                        color: HexColor(primaryColor),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }


  AwesomeDialog shoppingOptionPopUp(BuildContext context, double screenHeight) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      btnCancel: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Text(
          'Close',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 4, 10, 15),
        child: Column(
          children: [
            const Text(
              'How do you want to shop today?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: screenHeight / 67,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: HexColor(primaryColor),
                  borderRadius: BorderRadius.circular(8)),
              child: ElevatedButton(
                onPressed: performPlatformSpecificBarcodeScan,
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide.none),
                  backgroundColor: MaterialStateProperty.all(
                    HexColor(primaryColor),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/scan_icon.svg'),
                    const SizedBox(
                      width: 24,
                    ),
                    const Text(
                      'Scan barcodes',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 110,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: HexColor(primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductSearchBottomNavBar(
                      storeEntity: _dropdownValue!,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    HexColor(primaryColor),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.search_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Manually search for items',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget productScanView(
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
                      onTap: performPlatformSpecificBarcodeScan,
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
                      onTap: () => Navigator.pushReplacementNamed(
                          context, ProductSearchScreen.routeName,
                          arguments: storeEntity),
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
