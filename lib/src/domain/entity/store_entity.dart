import 'package:equatable/equatable.dart';

class StoreEntity extends Equatable {
  int? id;
  String? businessName;
  String? profilePhotoUrl;

  StoreEntity(
      {required this.id, required this.businessName, this.profilePhotoUrl});

  StoreEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessName = json['business_name'];
    profilePhotoUrl = json['profile_photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['business_name'] = businessName;
    data['profile_photo_url'] = profilePhotoUrl;
    return data;
  }

  @override
  String toString() {
    return 'Store{id: $id,business name: $businessName}';
  }

  @override
  List<Object?> get props => [id, businessName, profilePhotoUrl];
}
