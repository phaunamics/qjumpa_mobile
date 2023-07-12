import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/presentation/shopping_list/shopping_list.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.widget,
  });

  final double screenHeight;
  final double screenWidth;
  final Widget widget;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

bool isShoppingListClicked = false;

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    print('before tap $isShoppingListClicked');
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        height: widget.screenHeight / 10.8,
        width: widget.screenWidth / 1.7,
        child: Stack(
          children: [
            const DoodleBackground(
              opacity: 1,
            ),
            Container(
              height: widget.screenHeight / 10.8,
              width: widget.screenWidth / 1.7,
              color: HexColor(primaryColor).withOpacity(0.88),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.widget,
                    SizedBox(
                      width: widget.screenHeight / 23,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!isShoppingListClicked) {
                          Navigator.pushReplacementNamed(
                              context, ShoppingList.routeName);
                          isShoppingListClicked = true;
                          print('After tap $isShoppingListClicked');
                        } else {
                          null;
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset('assets/shopping_list_icon.svg'),
                          Text(
                            'Shopping list',
                            style: TextStyle(
                                fontSize: 12,
                                color: HexColor(fontColor),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
