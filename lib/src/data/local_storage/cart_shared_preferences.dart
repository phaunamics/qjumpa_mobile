import 'dart:async';
import 'dart:convert';

import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _cartKey = "cart_shared_preference_key";

class CartSharedPreferences {
  final SharedPreferences _sharedPreferences;
  final StreamController<int> _controller = StreamController.broadcast();
  final Map<int, StreamController<int>> _orderTotalControllers = {};
  final StreamController<int> _subTotalController =
      StreamController.broadcast();
  final StreamController<double> _surchargeController =
      StreamController.broadcast();
  final StreamController<double> _grandTotalController =
      StreamController.broadcast();

  Stream<int> get cartCountStream => _controller.stream;
  Stream<int> get subTotalStream => _subTotalController.stream;
  Stream<double> get surchargeStream => _surchargeController.stream;
  Stream<double> get grandTotalStream => _grandTotalController.stream;

  Stream<int> getOrderTotalStream(int orderId) {
    if (!_orderTotalControllers.containsKey(orderId)) {
      _orderTotalControllers[orderId] = StreamController.broadcast();
    }
    return _orderTotalControllers[orderId]!.stream;
  }

  int get totalItemsInCart => getCartItems().length;

  int qty(int orderId) {
    final List<Order> orders = List.from(getCartItems());
    final int index = orders.indexWhere((order) => order.orderId == orderId);
    if (!index.isNegative) {
      return orders[index].qty;
    } else {
      return 0;
    }
  }

  int get subTotal {
    final List<Order> orders = List.from(getCartItems());
    return orders.map((order) => order.total).toList().fold(0, (a, b) => a + b);
  }

  double get surcharge {
    // Calculate the surcharge as 0.3% of the subtotal, capped at 200
    double calculatedSurcharge = subTotal * 0.003;
    return calculatedSurcharge > 200 ? 200 : calculatedSurcharge;
  }

  double get grandTotal {
    // Calculate the grand total as the sum of subtotal and surcharge
    return subTotal + surcharge;
  }

  CartSharedPreferences(this._sharedPreferences) {
    _controller.add(getCartItems().length);
    _subTotalController.add(subTotal);
    _surchargeController.add(surcharge);
    _grandTotalController.add(grandTotal);
  }

  void addItemToCart(Order newOrder) async {
    var orders = List.from(getCartItems());
    final int index =
        orders.indexWhere((order) => order.orderId == newOrder.orderId);
    if (index.isNegative) {
      // newOrder = orders[index].copyWith(qty: 1);
      orders.add(newOrder.copyWith(qty: 1));
    } else {
      final Order oldOrder = orders[index];
      int oldOrderQuantity = oldOrder.qty;
      newOrder = oldOrder.copyWith(qty: oldOrderQuantity + 1);
      orders[index] = newOrder;
    }

    _sharedPreferences.setString(_cartKey, jsonEncode(orders));
    _controller.add(orders.length);
    _subTotalController.add(subTotal);
    _surchargeController.add(surcharge);
    _grandTotalController.add(grandTotal);

    if (_orderTotalControllers.containsKey(newOrder.orderId)) {
      _orderTotalControllers[newOrder.orderId]!.add(newOrder.total);
    }
  }

  void decreaseItemInCart(Order newOrder) async {
    var orders = List.from(getCartItems());
    final int index =
        orders.indexWhere((order) => order.orderId == newOrder.orderId);
    final Order oldOrder = orders[index];
    int oldOrderQuantity = oldOrder.qty;
    if (oldOrderQuantity > 1) {
      newOrder = oldOrder.copyWith(qty: oldOrderQuantity - 1);
      orders[index] = newOrder;
    } else {
      orders.removeAt(index); // Remove the order when quantity reaches zero
    }

    _sharedPreferences.setString(_cartKey, jsonEncode(orders));
    _controller.add(orders.length);
    _subTotalController.add(subTotal);
    _surchargeController.add(surcharge);
    _grandTotalController.add(grandTotal);

    if (_orderTotalControllers.containsKey(newOrder.orderId)) {
      _orderTotalControllers[newOrder.orderId]!.add(newOrder.total);
    }
  }

  void removeItemFromCart(Order order) async {
    final cartItems = getCartItems();
    cartItems.remove(order);
    _controller.add(cartItems.length);
    _subTotalController.add(subTotal);

    if (_orderTotalControllers.containsKey(order.orderId)) {
      _orderTotalControllers[order.orderId]!.close();
      _orderTotalControllers.remove(order.orderId);
    }
  }

  List<Order> getCartItems() {
    final res = _sharedPreferences.getString(_cartKey);
    if (res == null || res.isEmpty) return List.empty();
    return List.from(jsonDecode(res)).map((e) => Order.fromJson(e)).toList();
  }
}
