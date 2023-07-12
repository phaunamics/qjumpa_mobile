import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/core/usecase.dart';
import 'package:qjumpa/src/data/preferences/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/domain/usecases/get_inventory_usecase.dart';
import 'package:qjumpa/src/presentation/product_search/bloc/product_search_bloc.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/bottom_nav_bar.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav_icon.dart';
import 'package:qjumpa/src/presentation/widgets/custom_badge.dart';
import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';
import 'package:qjumpa/src/presentation/widgets/inventory_animated_container.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/productsearch';

  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final _searchBarController = TextEditingController();
  final getProductSearchBloc = sl.get<ProductSearchBloc>();
  final getInventoryUseCase = sl.get<GetInventoryUseCase>();
  final _cartSharedPref = sl.get<CartSharedPreferences>();
  List<Inventory>? cachedInventory;
  bool isInventoryFetched = false;

  void fetchInventory() async {
    if (!isInventoryFetched) {
      cachedInventory = await getInventoryUseCase.call(NoParams());
      isInventoryFetched = true;
    }
  }

  @override
  void initState() {
    fetchInventory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: BlocBuilder<ProductSearchBloc, ProductSearchState>(
      bloc: getProductSearchBloc,
      builder: (context, state) {
        if (state is ProductSearchingState) {
          return Stack(
            children: [
              const DoodleBackground(),
              Positioned(
                top: screenHeight / 5,
                left: screenHeight / 6,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Looking for a match...'),
                      SizedBox(
                        height: screenHeight / 34,
                      ),
                      CircularProgressIndicator(
                        color: HexColor(primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (state is ProductSearchCompletedState) {
          if (state.inventory!.isEmpty) {
            return buildScreen(
              screenHeight: screenHeight,
              context: context,
              screenWidth: screenWidth,
              widget: SizedBox(
                height: screenHeight / 1.8,
                child: Center(
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/not_found.svg'),
                      const Text(
                        'Item not found',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return buildScreen(
              screenHeight: screenHeight,
              context: context,
              screenWidth: screenWidth,
              widget: SizedBox(
                height: screenHeight / 1.8,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  itemBuilder: (_, int index) {
                    final inventory = state.inventory![index];

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 10, 6, 6),
                      child: CustomAnimatedContainer(
                        order: inventory.order,
                      ),
                    );
                  },
                  itemCount: state.inventory!.length,
                ),
              ),
            );
          }
        } else if (state is ErrorState) {
          return buildScreen(
              screenHeight: screenHeight,
              context: context,
              screenWidth: screenWidth,
              widget: Padding(
                padding: EdgeInsets.only(bottom: screenHeight / 6.4),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight / 12,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child:
                            Image.asset('assets/No Internet Connection.png')),
                  ],
                ),
              ));
        }
        return buildScreen(
          context: context,
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          widget: SizedBox(
            height: screenHeight / 1.78,
          ),
        );
      },
    ));
  }

  Widget buildScreen(
      {required double screenHeight,
      required BuildContext context,
      required double screenWidth,
      required Widget widget}) {
    return Stack(
      children: [
        const DoodleBackground(),
        Positioned(
          top: screenHeight / 15,
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
                      // IconButton(
                      //   icon: const Icon(Icons.chevron_left_outlined),
                      //   onPressed: () => Navigator.pop(context),
                      //   iconSize: 35,
                      //   color: HexColor(primaryColor),
                      // ),
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
                  SizedBox(
                    height: screenHeight / 11.4,
                  ),
                  CustomTextFormField(
                      hint: 'Search by product name',
                      label: '',
                      focus: true,
                      hintFontSize: 16,
                      onChanged: (value) => getProductSearchBloc
                          .add(Search(value, cachedInventory)),
                      height: screenHeight / 15,
                      suffixIcon: const Icon(Icons.search),
                      controller: _searchBarController,
                      value: false),
                  widget,
                  SizedBox(
                    height: screenHeight / 42,
                  ),
                  Center(
                    child: BottomNavBar(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        widget: BottomNavIcon(
                          value: 'Scan',
                          onTap: null,
                          widget: SvgPicture.asset('assets/scan_icon.svg'),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
