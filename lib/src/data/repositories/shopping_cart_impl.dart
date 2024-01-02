import 'package:qjumpa/src/data/data_sources/get_shopping_cart_data_source.dart';
import 'package:qjumpa/src/domain/entity/shopping_cart_entity.dart';
import 'package:qjumpa/src/domain/repositories/shopping_cart_repository.dart';

class ShoppingCartImpl implements ShoppingCartRepository {
  final GetShoppingCartRemoteDataSource getShoppingCartRemoteDataSource;

  ShoppingCartImpl(this.getShoppingCartRemoteDataSource);

  @override
  Future<ShoppingCartEntity?> getShoppingCart(String userId) {
    return getShoppingCartRemoteDataSource.getShoppingCart(userId);
  }
}