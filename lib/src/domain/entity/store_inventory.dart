import 'order_entity.dart';

class Inventory {
  int? id;
  int? storeId;
  String? name;
  String? sku;
  int? price;
  String? photoUrl;
  DateTime? lastPurchasedAt;
  String? createdAt;
  String? updatedAt;

  Order get order {
    return Order(
      itemName: name ?? '',
      productId: id ?? 0,
      price: price ?? 0,
      qty: 1, //TODO:changed value from zero to one
      orderId: DateTime.now().microsecondsSinceEpoch,
    );
  }

  Inventory(
      {this.id,
      this.storeId,
      this.name,
      this.sku,
      this.price,
      this.photoUrl,
      this.lastPurchasedAt,
      this.createdAt,
      this.updatedAt});

  Inventory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['user_id'];
    name = json['name'];
    sku = json['sku'];
    price = json['price'];
    photoUrl = json['photo'];
    lastPurchasedAt = json['last_purchased_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = storeId;
    data['name'] = name;
    data['sku'] = sku;
    data['price'] = price;
    data['photo'] = photoUrl;
    data['last_purchased_at'] = lastPurchasedAt ?? '';
    data['created_at'] = createdAt ?? '';
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'Inventory{id: $id,name: $name,price: $price,sku: $sku}';
  }
}
