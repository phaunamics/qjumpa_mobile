import 'package:qjumpa/src/domain/entity/order_entity.dart';

class UserCart {
  final Map<String, Order> cartItems;

  UserCart(this.cartItems);

  UserCart removeItem(String itemName) {
    if (cartItems.containsKey(itemName)) {
      cartItems.removeWhere((key, _) => key == itemName);
    }
    return UserCart(cartItems);
  }

  UserCart updateCart(String itemName, int qty) {
    if (cartItems.containsKey(itemName)) {
      Order order = cartItems[itemName]!;
      //order.qty = qty;
      cartItems[itemName] = order;
    }
    return UserCart(cartItems);
  }

  int get grandTotal {
    return cartItems.values
        .map((e) => e.total)
        .fold(0, (a, b) => a.toInt() + b.toInt());
  }

  void addToCart(String name, Order order) {
    cartItems[name] = order;
  }

  @override
  String toString() {
    return 'User{cartItems: $cartItems}';
  }
}

final currentUserCart = UserCart({});
