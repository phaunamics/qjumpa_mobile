import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/domain/entity/store_entity.dart';
import 'package:qjumpa/src/presentation/product_search/product_search_screen_.dart';
import 'package:qjumpa/src/presentation/select_store/select_store_screen.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/shopping_list_nav_bar.dart';

class ProductSearchBottomNavBar extends StatefulWidget {
  static const routeName = '/productSeearchNavBar';
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
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SelectStoreScreen(),
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
            icon: SvgPicture.asset(
              'assets/shop_icon.svg',
            ),
            label: 'Shop',
            activeIcon: SvgPicture.asset('assets/shop_selected.svg'),
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/shopping_list_icon.svg'),
              activeIcon: SvgPicture.asset('assets/shopping_list_selected.svg'),
              label: 'Shopping List'),
        ],
      ),
    );
  }
}
