import 'package:qjumpa/src/core/usecase.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/domain/repositories/inventory_repository.dart';

class GetInventoryUseCase extends UseCase<List<Inventory>, NoParams> {
  final InventoryRepository inventoryRepository;

  GetInventoryUseCase(this.inventoryRepository);

  @override
  Future<List<Inventory>> call(NoParams params) async {
    return await inventoryRepository.getInventory();
  }
}
