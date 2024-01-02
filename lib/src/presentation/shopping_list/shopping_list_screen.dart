import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/data/local_storage/item_shared_preferences.dart';
import 'package:qjumpa/src/presentation/profile/profile_screen.dart';
import 'package:qjumpa/src/presentation/shopping_list/create_new_list.dart';
import 'package:qjumpa/src/presentation/widgets/collapsible_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingListScreen extends StatefulWidget {
  static const routeName = '/shopping_list';
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final shoppingListSharedPref = sl.get<ShoppingListSharedPreferences>();
  final _prefs = sl.get<SharedPreferences>();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: screenHeight / 15,
            child: Container(
              color: Colors.white,
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
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight / 104,
                    ),
                    Row(
                      children: [
                        customText(
                            text: 'by ',
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.5)),
                        GestureDetector(
                          onTap: () => _prefs.getString(authTokenKey) == null
                              ? null
                              : Navigator.pushNamed(
                                  context, ProfileScreen.routeName),
                          child: customText(
                            text:
                                '@${_prefs.getString(userEmail)?.split('@')[0]}',
                            color: Colors.black,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
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
                      height: screenHeight / 12,
                    ),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8))),
                        context: context,
                        builder: (context) {
                          return const CreateNewListScreen();
                        },
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 32.0),
                            child: Text(
                              'Create a New List',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            width: screenHeight / 25,
                          ),
                          Icon(
                            Icons.create,
                            color: HexColor(primaryColor),
                          ),
                        ],
                      ),
                    ),
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
