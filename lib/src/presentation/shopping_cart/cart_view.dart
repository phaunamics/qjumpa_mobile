import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/services/firebase_auth.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/payment/paystack_payment_channel.dart';
import 'package:qjumpa/src/presentation/widgets/item_card.dart';
import 'package:qjumpa/src/presentation/widgets/small_button.dart';

class CartView extends StatefulWidget {
  static const routeName = '/cartView';

  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final cartSharedPref = sl.get<CartSharedPreferences>();

  final _auth = sl.get<Auth>();

  void checkIfUserIsLoggedIn() {
    if (_auth.currentUser != null) {
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        context: context,
        builder: (context) => const PaystackPaymentChannel(),
      );
    } else {
      loginRequestPopUp(context).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cart',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close,
                              size: 30, color: Colors.red),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight / 54,
                    ),
                    Expanded(child: shoppingCartListView(screenHeight)),
                    Divider(
                      height: screenHeight / 98,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            StreamBuilder<int>(
                              stream: cartSharedPref.subTotalStream,
                              builder: (context, snapshot) {
                                return subTotalCard(
                                    value: snapshot.data ??
                                        cartSharedPref.subTotal);
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Surcharge',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            StreamBuilder<double>(
                              stream: cartSharedPref.surchargeStream,
                              builder: (context, snapshot) {
                                return surChargeCard(
                                    value: snapshot.data ??
                                        cartSharedPref.surcharge);
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Grand Total',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            StreamBuilder<double>(
                              stream: cartSharedPref.grandTotalStream,
                              builder: (context, snapshot) {
                                return grandTotalCard(
                                    value: snapshot.data ??
                                        cartSharedPref.grandTotal);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight / 45),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SmallBtn(
                        text: 'Pay',
                        onTap: () {
                          checkIfUserIsLoggedIn();
                        },
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        width: 157,
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

  Widget subTotalCard({required int value}) {
    return Text(
      NumberFormat.currency(symbol: '₦ ').format(value),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
    );
  }

  Widget surChargeCard({required double value}) {
    return Text(
      NumberFormat.currency(symbol: '₦ ').format(value),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
    );
  }

  Widget grandTotalCard({required double value}) {
    return Text(
      NumberFormat.currency(symbol: '₦ ').format(value),
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  Widget shoppingCartListView(double screenHeight) {
    return SizedBox(
      height: screenHeight / 1.43,
      child: StreamBuilder<int>(
        stream: cartSharedPref.cartCountStream,
        initialData: cartSharedPref.totalItemsInCart,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data! > 0) {
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              itemCount: cartSharedPref.totalItemsInCart,
              itemBuilder: (context, index) {
                final Order order = cartSharedPref.getCartItems()[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ItemCard(order: order),
                );
              },
            );
          } else {
            return Column(
              children: [
                const Image(
                  image: AssetImage('assets/empty_cart.jpeg'),
                ),
                const Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: screenHeight / 32,
                ),
                const Text(
                  'Scan the barcode on any product on\nthe shelf or search for it to add it to\nyour cart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                )
              ],
            );
          }
        },
      ),
    );
  }

  AwesomeDialog loginRequestPopUp(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      padding: const EdgeInsets.all(6),
      desc: 'Please login or register to proceed to payment',
      btnOk: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(
            context, LoginView.routeName,
            arguments: ModalRoute.of(context)!.settings.name),
        child: Container(
          height: 55,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: HexColor(primaryColor),
              borderRadius: BorderRadius.circular(8)),
          child: const Center(
            child: Text(
              'Login',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
