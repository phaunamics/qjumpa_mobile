import 'order_entity.dart';

class Inventory {
  int? id;
  int? userId;
  String? name;
  String? sku;
  int? price;
  int? stock;
  String? photo;
  DateTime? lastPurchasedAt;
  String? createdAt;
  String? updatedAt;

  Order get order {
    return Order(
      itemName: name ?? '',
      productId: DateTime.now().microsecondsSinceEpoch.toString(),
      price: price ?? 0,
      qty: 0,
      orderId: id ?? 0,
    );
  }

  Inventory(
      {this.id,
      this.userId,
      this.name,
      this.sku,
      this.price,
      this.stock,
      this.photo,
      this.lastPurchasedAt,
      this.createdAt,
    this.updatedAt});

  Inventory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    sku = json['sku'];
    price = json['price'];
    stock = json['stock'];
    photo = json['photo'];
    lastPurchasedAt = json['last_purchased_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['sku'] = sku;
    data['price'] = price;
    data['stock'] = stock;
    data['photo'] = photo;
    data['last_purchased_at'] = lastPurchasedAt ?? '';
    data['created_at'] = createdAt ?? '';
    data['updated_at'] = updatedAt;
    return data;
  }
}
