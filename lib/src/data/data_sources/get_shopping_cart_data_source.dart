import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/domain/entity/shopping_cart_entity.dart'; // Ensure you have this import for jsonDecode

abstract class GetShoppingCartRemoteDataSource {
  Future<ShoppingCartEntity?> getShoppingCart(String userId);
}

class GetShoppingCartRemoteDataSourceImpl
    implements GetShoppingCartRemoteDataSource {
  final UserAuthService userAuthService;

  GetShoppingCartRemoteDataSourceImpl({required this.userAuthService});

  @override
  Future<ShoppingCartEntity?> getShoppingCart(String userId) async {
    try {
      final response = await userAuthService
          .getShoppingCart(getShoppingCartEndPiont(userId));
      final ShoppingCartEntity shoppingCart =
          ShoppingCartEntity.fromJson(response);
      return shoppingCart;
    } catch (error) {
      rethrow; 
    }
  }
}
