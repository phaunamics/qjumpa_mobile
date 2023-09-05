// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:qjumpa/injection.dart';
// import 'package:qjumpa/src/data/preferences/cart_shared_preferences.dart';
// import 'package:qjumpa/src/domain/entity/store_inventory.dart';
// import 'package:qjumpa/src/presentation/product_search/bloc/product_search_bloc.dart';
// import 'package:qjumpa/src/presentation/shopping_list/shopping_list.dart';
// import 'package:qjumpa/src/presentation/widgets/bottom_nav/bottom_nav_bar.dart';
// import 'package:qjumpa/src/presentation/widgets/custom_badge.dart';
// import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';

// class ProductSearchScreenView extends StatefulWidget {
//   final String? storeId;
//   final List<Inventory>? cachedInventory;
//   final Widget widget;
//   const ProductSearchScreenView(
//       {super.key, this.storeId, required this.widget, this.cachedInventory});

//   @override
//   State<ProductSearchScreenView> createState() =>
//       _ProductSearchScreenViewState();
// }

// class _ProductSearchScreenViewState extends State<ProductSearchScreenView> {
//   final _cartSharedPref = sl.get<CartSharedPreferences>();
//     final getProductSearchBloc = sl.get<ProductSearchBloc>();
//       final _searchBarController = TextEditingController();



//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//     var screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             top: screenHeight / 15,
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: screenWidth / 17),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         StreamBuilder<int>(
//                           stream: _cartSharedPref.cartCountStream,
//                           initialData: _cartSharedPref.totalItemsInCart,
//                           builder: (context, snapshot) {
//                             return CustomBadge(
//                               badgeCount: snapshot.data ?? 0,
//                             );
//                           },
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: screenHeight / 11.4,
//                     ),
//                     CustomTextFormField(
//                         hint: 'Search by product name',
//                         label: '',
//                         focus: true,
//                         hintFontSize: 16,
//                         onChanged: (value) {
//                           if (value != null) {
//                             getProductSearchBloc.add(Search(
//                                 value.isNotEmpty ? value : '',
//                                 widget.storeId ?? '',
//                                 widget.cachedInventory ?? []));
//                           }
//                         },
//                         height: screenHeight / 15,
//                         suffixIcon: const Icon(Icons.search),
//                         controller: _searchBarController,
//                         value: false),
//                     widget,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavBar(
//           pages: [
//             buildScreen(
//                 screenHeight: screenHeight,
//                 context: context,
//                 screenWidth: screenWidth,
//                 storeId: widget.storeEntity?.id.toString(),
//                 widget: const SizedBox()),
//             const ShoppingList()
//           ],
//           currentIndex: 0,
//           customWidget: SvgPicture.asset(
//             'assets/shop_icon.svg',
//           ),
//         ),,
//     );
//   }
// }
