import 'package:qjumpa/src/core/utils/usecase.dart';
import 'package:qjumpa/src/domain/entity/shopping_cart_entity.dart';
import 'package:qjumpa/src/domain/repositories/shopping_cart_repository.dart';

class GetShoppingCartUseCase extends UseCase<ShoppingCartEntity?, String> {
  final ShoppingCartRepository shoppingCartRepository;

  GetShoppingCartUseCase(this.shoppingCartRepository);

  @override
  Future<ShoppingCartEntity?> call(String? params) async {
    return await shoppingCartRepository.getShoppingCart(params!);
  }
}
