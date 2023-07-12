import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/data/preferences/item_shared_preferences.dart';
import 'package:qjumpa/src/presentation/profile/profile_screen.dart';
import 'package:qjumpa/src/presentation/shopping_list/create_new_list.dart';
import 'package:qjumpa/src/presentation/store_search/store_search_screen.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/bottom_nav_bar.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav_icon.dart';
import 'package:qjumpa/src/presentation/widgets/collapsible_container.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';

class ShoppingList extends StatefulWidget {
  static const routeName = '/shopping_list';
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

bool isShopIcon = false;

class _ShoppingListState extends State<ShoppingList> {
  final shoppingListSharedPref = sl.get<ShoppingListSharedPreferences>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          const DoodleBackground(),
          Positioned(
            top: screenHeight / 15,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight / 41.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                            text: 'Shopping List',
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                        GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, ProfileScreen.routeName),
                            child: CircleAvatar(
                              backgroundColor: HexColor(primaryColor),
                              radius: screenHeight / 50,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight / 100,
                    ),
                    // Row(
                    //   children: [
                    //     customText(
                    //       text: 'for ',
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () => Navigator.pushNamed(
                    //           context, ProfileScreen.routeName),
                    //       child: customText(
                    //         text: '@tententa >>',
                    //         color: HexColor(primaryColor),
                    //         decoration: TextDecoration.underline,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: screenHeight / 86,
                    ),
                    customText(
                      text: 'Having trouble creating a list?',
                      color: HexColor(fontColor),
                    ),
                    Row(
                      children: [
                        customText(
                            text: 'Explore lists', color: HexColor(fontColor)),
                        GestureDetector(
                          onTap: null,
                          child: customText(
                            text: ' here>>',
                            color: HexColor(primaryColor),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: screenHeight / 1.7,
                        // color: Colors.green,
                        child: const CollapsibleContainer(),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 45,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, CreateNewListScreen.routeName),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Create a new list',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: screenHeight / 65,
                          ),
                          CircleAvatar(
                            backgroundColor: HexColor(primaryColor),
                            radius: screenHeight / 34,
                            child: const Icon(
                              Icons.add_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BottomNavBar(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          widget: BottomNavIcon(
                            value: 'Shop',
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, StoreSearchScreen.routeName);
                              isShoppingListClicked = false;
                            },
                            widget: const Icon(
                              Icons.shopping_cart_checkout_outlined,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget customText({
    required String text,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
    double fontSize = 15,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return Text(
      text,
      style: TextStyle(
          letterSpacing: 1,
          fontWeight: fontWeight,
          decoration: decoration,
          decorationColor: decorationColor,
          fontSize: fontSize,
          color: color),
    );
  }
}
