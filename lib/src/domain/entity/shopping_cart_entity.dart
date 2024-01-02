// ignore_for_file: public_member_api_docs, sort_constructors_first
class ShoppingCartEntity {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  ShoppingCartEntity({this.success, this.statusCode, this.message, this.data});

  ShoppingCartEntity.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? customerId;
  int? storeId;
  int? totalAmount;
  String? createdAt;
  String? updatedAt;
  List<CartItems>? cartItems;

  Data(
      {this.id,
      this.customerId,
      this.storeId,
      this.totalAmount,
      this.createdAt,
      this.updatedAt,
      this.cartItems});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    storeId = json['store_id'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['cart_items'] != null) {
      cartItems = <CartItems>[];
      json['cart_items'].forEach((v) {
        cartItems!.add(CartItems.fromJson(v));
      });
    }
    //cartItems = List<CartItems>.from(json['cart_items']).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['store_id'] = storeId;
    data['total_amount'] = totalAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (cartItems != null) {
      data['cart_items'] = cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Data(id: $id, customerId: $customerId, storeId: $storeId, totalAmount: $totalAmount, createdAt: $createdAt, updatedAt: $updatedAt, cartItems: $cartItems)';
  }
}

class CartItems {
  int? id;
  int? cartId;
  int? productId;
  String? name;
  int? price;
  int? quantity;
  int? totalAmount;
  String? createdAt;
  String? updatedAt;

  CartItems(
      {this.id,
      this.cartId,
      this.productId,
      this.name,
      this.price,
      this.quantity,
      this.totalAmount,
      this.createdAt,
      this.updatedAt});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    productId = json['product_id'];
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['name'] = name;
    data['price'] = price;
    data['quantity'] = quantity;
    data['total_amount'] = totalAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'CartItems(id: $id, cartId: $cartId, productId: $productId, name: $name, price: $price, quantity: $quantity, totalAmount: $totalAmount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
