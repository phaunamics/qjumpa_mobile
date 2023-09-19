import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/presentation/select_store/select_store_screen.dart';
import 'package:qjumpa/src/presentation/shopping_list/shopping_list_screen.dart';

class ShoppingListNavBar extends StatefulWidget {
  // final Widget customWidget;
  // final String? iconName;
  // final List<Widget> pages;
  // int currentIndex;
  const ShoppingListNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<ShoppingListNavBar> createState() => _ShoppingListNavBarState();
}

class _ShoppingListNavBarState extends State<ShoppingListNavBar> {
  int _currentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    const SelectStoreScreen(),
    const ShoppingListScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        unselectedItemColor: const Color(0xff828282),
        backgroundColor: HexColor(primaryColor),
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/shop_icon.svg',
              ),
              label: 'Shop',
              activeIcon: SvgPicture.asset('assets/shop_selected.svg')),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/shopping_list_icon.svg'),
              activeIcon: SvgPicture.asset('assets/shopping_list_selected.svg'),
              label: 'Shopping List'),
        ],
      ),
    );
  }
}
