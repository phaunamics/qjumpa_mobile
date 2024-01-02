import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/domain/usecases/get_shopping_cart_usecase.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/payment/payment_success.dart';
import 'package:qjumpa/src/presentation/payment/paystack_payment_channel.dart';
import 'package:qjumpa/src/presentation/widgets/cart_item_card.dart';
import 'package:qjumpa/src/presentation/widgets/small_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartView extends StatefulWidget {
  static const routeName = '/cartView';

  const CartView({
    super.key,
  });

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final _prefs = sl.get<SharedPreferences>();
  final getshoppingCartUsecase = sl.get<GetShoppingCartUseCase>();
  // final cartBloc = sl.get<CartBloc>();

  void checkIfUserIsLoggedIn({int? grandTotal}) {
    if (_prefs.getString(authTokenKey) != null) {
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        context: context,
        builder: (context) => PaystackPaymentChannel(
          grandTotal: grandTotal ?? 0,
          callback: (bool status, String reference) {
            if (status) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccess(
                    isSuccesful: status,
                    reference: reference,
                  ),
                ),
                ModalRoute.withName('/'),
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccess(
                    isSuccesful: status,
                    reference: reference,
                  ),
                ),
                ModalRoute.withName('/'),
              );
            }
          },
        ),
      );
    } else {
      loginRequestPopUp(context).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(Icons.close, size: 30, color: Colors.red),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 54,
                ),
                Expanded(child: shoppingCartListView(screenHeight)),
              ],
            ),
          ),
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

  Widget grandTotalCard({required num value}) {
    return Text(
      NumberFormat.currency(symbol: '₦ ').format(value),
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  Widget shoppingCartListView(double screenHeight) {
    return SizedBox(
      height: screenHeight / 1.43,
      child: FutureBuilder(
        future: getshoppingCartUsecase.call(_prefs.getInt(userId).toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data != null) {
            final shoppingCart = snapshot.data;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    itemCount: shoppingCart!.data?.cartItems?.length ?? 0,
                    itemBuilder: (context, index) {
                      final cartItem = shoppingCart.data!.cartItems![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: CartItemCard(
                          itemName: cartItem.name ?? '',
                          price: cartItem.price ?? 0,
                          qty: cartItem.quantity ?? 0,
                          totalAmount: cartItem.totalAmount ?? 0,
                        ),
                      );
                    },
                  ),
                ),
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
                        subTotalCard(
                            value:
                                0) //TODO: Ask favour to make subtotal from backend,
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
                        surChargeCard(
                            value:
                                0), //TODO: Ask favour to make surcharge from backend,
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
                        grandTotalCard(
                            value: shoppingCart.data?.totalAmount! ?? 0),
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
                      checkIfUserIsLoggedIn(
                          grandTotal: snapshot.data!.data?.totalAmount);
                    },
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    width: 157,
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: HexColor(primaryColor),
              ),
            );
          } else if (snapshot.data?.data == null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
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
          } else {
            return Text('An error occured ${snapshot.error}');
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
