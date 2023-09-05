import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';

class BottomNavBar extends StatefulWidget {
  final Widget customWidget;
  final String? iconName;
  final List<Widget> pages;
  int currentIndex;
  BottomNavBar(
      {Key? key,
      required this.customWidget,
      this.iconName,
      this.currentIndex = 1,
      required this.pages})
      : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // int _currentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  // static const List<Widget> _pages = <Widget>[
  //   StoreSearchScreen(),
  //   ShoppingList()
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.pages.elementAt(widget.currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        unselectedItemColor: const Color(0xff828282),
        backgroundColor: HexColor(primaryColor),
        items: [
          BottomNavigationBarItem(
              icon: widget.customWidget,
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
