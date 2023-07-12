import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/presentation/product_scan/product_scan_screen.dart';
import 'package:qjumpa/src/presentation/product_search/product_search_screen.dart';
import 'package:qjumpa/src/presentation/store_search/bloc/barcodescanner_bloc.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';
import 'package:qjumpa/src/presentation/widgets/ios_scanner_view.dart';
import 'package:qjumpa/src/presentation/widgets/large_btn.dart';

class StoreSearchScreen extends StatefulWidget {
  static const routeName = '/storesearch';
  const StoreSearchScreen({super.key});

  @override
  State<StoreSearchScreen> createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  String _dropdownValue = 'What supermarket are you in?';
  final getBarcodeScannerbloc = sl.get<BarcodeScannerBloc>();

  void performPlatformSpecificBarcodeScan() {
    if (Platform.isAndroid) {
      getBarcodeScannerbloc.add(Scan());
    } else if (Platform.isIOS) {
      Navigator.pushNamed(context, IOSScannerView.routeName);
    } else {
      // Perform default action if the platform is not recognized
      // print('Platform not recognized');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<BarcodeScannerBloc, BarcodescannerState>(
      bloc: getBarcodeScannerbloc,
      listener: (context, state) {
        if (state is BarcodescannerCompleted) {
          Navigator.pushNamed(context, ProductScanScreen.routeName,
              arguments: state.inventory);
        }
      },
      child: Scaffold(
        body: BlocBuilder<BarcodeScannerBloc, BarcodescannerState>(
          bloc: getBarcodeScannerbloc,
          builder: (context, state) {
            if (state is BarcodescannerInitial) {
              initialBuild(screenHeight, context);
            }
            return initialBuild(screenHeight, context);
          },
        ),
      ),
    );
  }

  Stack initialBuild(double screenHeight, BuildContext context) {
    return Stack(
      children: [
        const DoodleBackground(
          opacity: 1,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField(
                  value: _dropdownValue,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.9),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.9),
                    ),
                  ),
                  items: <String>[
                    'What supermarket are you in?',
                    'Blenco',
                    'Shop Rite',
                    'Qjumpa Stores'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownValue = newValue!;
                    });
                  }),
            ),
            SizedBox(
              height: screenHeight / 21,
            ),
            LargeBtn(
              onTap: _dropdownValue == 'What supermarket are you in?'
                  ? null
                  : () => shoppingOption(context, screenHeight, screenHeight),
              text: 'Start Shopping',
              letterSpacing: 1,
              fontSize: 16,
              color: _dropdownValue != 'What supermarket are you in?'
                  ? HexColor(primaryColor)
                  : Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            )
          ],
        )
      ],
    );
  }

  Future<void> shoppingOption(
      BuildContext context, double width, double height) {
    return showModalBottomSheet(
        context: context,
        elevation: 0,
        builder: (context) {
          return SizedBox(
            width: width * 0.23,
            height: height / 3.5,
            child: Column(
              children: [
                SizedBox(
                  height: height / 32,
                ),
                LargeBtn(
                  onTap: performPlatformSpecificBarcodeScan,
                  text: 'Scan item barcode and add to cart',
                  color: HexColor(primaryColor),
                  fontSize: 14,
                ),
                SizedBox(
                  height: height / 45,
                ),
                LargeBtn(
                  onTap: () => Navigator.pushReplacementNamed(
                      context, ProductSearchScreen.routeName),
                  color: HexColor(primaryColor),
                  text: 'Search store inventory and manually add to cart',
                  fontSize: 14,
                )
              ],
            ),
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ));
  }
}
