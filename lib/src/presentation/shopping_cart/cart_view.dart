import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:qjumpa/src/presentation/payment/paystack_payment_channel.dart';
import 'package:qjumpa/src/presentation/widgets/shopping_cart_item_card.dart';
import 'package:qjumpa/src/presentation/widgets/small_button.dart';

class CartView extends StatelessWidget {
  static const routeName = '/cartView';

  final cartSharedPref = sl.get<CartSharedPreferences>();

  CartView({super.key});

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
                    Expanded(child: shoopingCartListView(screenHeight)),
                    Divider(
                      height: screenHeight / 98,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        StreamBuilder<int>(
                          stream: cartSharedPref.subTotalStream,
                          builder: (context, snapshot) {
                            return subTotalCard(
                                value:
                                    snapshot.data ?? cartSharedPref.subTotal);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight / 45),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SmallBtn(
                        text: 'Pay',
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                const PaystackPaymentChannel(),
                          );
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
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  Widget shoopingCartListView(double screenHeight) {
    return SizedBox(
      height: screenHeight / 1.43,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
        itemCount: cartSharedPref.totalItemsInCart,
        itemBuilder: (context, index) {
          final Order order = cartSharedPref.getCartItems()[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ItemCard(order: order),
          );
        },
      ),
    );
  }
}
