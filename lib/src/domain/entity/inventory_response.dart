import 'package:qjumpa/src/domain/entity/store_inventory.dart';

class InventoryResponseEntity {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  InventoryResponseEntity(
      {this.success, this.statusCode, this.message, this.data});

  InventoryResponseEntity.fromJson(Map<String, dynamic> json) {
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
  String? businessName;
  String? email;
  DateTime? emailVerifiedAt;
  String? username;
  String? profilePhotoPath;
  String? createdAt;
  String? updatedAt;
  List<Inventory>? inventory;

  Data(
      {this.id,
      this.businessName,
      this.email,
      this.emailVerifiedAt,
      this.username,
      this.profilePhotoPath,
      this.createdAt,
      this.updatedAt,
      this.inventory});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessName = json['business_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    username = json['username'];
    profilePhotoPath = json['profile_photo_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['products'] != null) {
      inventory = <Inventory>[];
      json['products'].forEach((v) {
        inventory!.add(Inventory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['business_name'] = businessName;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['username'] = username;
    data['profile_photo_path'] = profilePhotoPath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (inventory != null) {
      data['products'] = inventory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Products {
//   int? id;
//   int? storeId;
//   String? name;
//   String? sku;
//   String? price;
//   Null? photoUrl;
//   Null? lastPurchasedAt;
//   String? createdAt;
//   String? updatedAt;

//   Products(
//       {this.id,
//       this.storeId,
//       this.name,
//       this.sku,
//       this.price,
//       this.photoUrl,
//       this.lastPurchasedAt,
//       this.createdAt,
//       this.updatedAt});

//   Products.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     storeId = json['store_id'];
//     name = json['name'];
//     sku = json['sku'];
//     price = json['price'];
//     photoUrl = json['photo_url'];
//     lastPurchasedAt = json['last_purchased_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['store_id'] = this.storeId;
//     data['name'] = this.name;
//     data['sku'] = this.sku;
//     data['price'] = this.price;
//     data['photo_url'] = this.photoUrl;
//     data['last_purchased_at'] = this.lastPurchasedAt;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
