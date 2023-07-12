import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/data/preferences/cart_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:qjumpa/src/presentation/paystack/bloc/payment_channel_bloc.dart';
import 'package:qjumpa/src/presentation/paystack/payment_method_view.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';
import 'package:qjumpa/src/presentation/widgets/item_card.dart';
import 'package:qjumpa/src/presentation/widgets/small_btn.dart';

class CartView extends StatelessWidget {
  static const routeName = '/cartView';

  final cartSharedPref = sl.get<CartSharedPreferences>();
  final paymentChannelBloc = sl.get<PaymentChannelBloc>();

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const DoodleBackground(),
            Container(
              color: Colors.white.withOpacity(0.4),
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
                    buildListView(screenHeight),
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
                    SmallBtn(
                      text: 'Pay',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const PaymentMethod(),
                        );
                      },
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      width: 157,
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

  Widget buildListView(double screenHeight) {
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
