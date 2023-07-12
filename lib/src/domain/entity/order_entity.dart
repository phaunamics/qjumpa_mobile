class Order {
  final int orderId;
  final String itemName;
  final String productId;
  final int qty;

  final int price;

  int get total => price * qty;

  Order({
    required this.itemName,
    required this.productId,
    required this.price,
    required this.qty,
    required this.orderId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      itemName: json['itemName'],
      productId: json['productId'],
      price: json['price'],
      qty: json['qty'],
      orderId: json['orderId'],
    );
  }

  Order copyWith({
    int? orderId,
    String? itemName,
    String? productId,
    int? qty,
    int? total,
    int? price,
  }) {
    return Order(
      itemName: itemName ?? this.itemName,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      orderId: orderId ?? this.orderId,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemName'] = itemName;
    data['productId'] = productId;
    data['price'] = price;
    data['qty'] = qty;
    data['orderId'] = orderId;
    return data;
  }

  @override
  String toString() {
    return 'Order{orderId: $orderId, itemName: $itemName, productId: $productId, qty: $qty, price: $price}';
  }
}
