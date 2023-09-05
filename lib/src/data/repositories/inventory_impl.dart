import 'package:qjumpa/src/data/data_sources/get_inventory_remote_data_src.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/domain/repositories/inventory_repository.dart';

class InventoryImpl implements InventoryRepository {
  final GetInventoryRemoteDataSource getInventoryRemoteDataSource;

  InventoryImpl(this.getInventoryRemoteDataSource);

  @override
  Future<List<Inventory>> getInventory(String storeId) {
    return getInventoryRemoteDataSource.getStoreInventory(storeId);
  }
}
