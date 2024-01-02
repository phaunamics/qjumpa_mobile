import 'package:qjumpa/src/domain/entity/shopping_cart_entity.dart';

abstract class ShoppingCartRepository {
  Future<ShoppingCartEntity?> getShoppingCart(String userId);
}
