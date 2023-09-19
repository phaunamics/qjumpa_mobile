import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/domain/entity/store_entity.dart';
import 'package:qjumpa/src/presentation/product_search/product_search_screen_.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/shopping_list_nav_bar.dart';

class ProductSearchBottomNavBar extends StatefulWidget {
  final StoreEntity storeEntity;
  const ProductSearchBottomNavBar({
    Key? key,
    required this.storeEntity,
  }) : super(key: key);

  @override
  State<ProductSearchBottomNavBar> createState() =>
      _ProductSearchBottomNavBarState();
}

class _ProductSearchBottomNavBarState extends State<ProductSearchBottomNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ShoppingListNavBar(),
        ),
      );
    }
  }

  final List<Widget> _pages = <Widget>[];

  @override
  void initState() {
    _pages.addAll([
      ProductSearchScreen(storeEntity: widget.storeEntity),
      const ShoppingListNavBar(),
    ]);
    super.initState();
  }

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
              icon: const Icon(
                Icons.search_rounded,
                size: 26,
              ),
              label: 'Shop',
              activeIcon: Icon(
                Icons.search_rounded,
                size: 26,
                color: HexColor(selectedTabBarColor),
              )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/shopping_list_icon.svg'),
              activeIcon: SvgPicture.asset('assets/shopping_list_selected.svg'),
              label: 'Shopping List'),
        ],
      ),
    );
  }
}
