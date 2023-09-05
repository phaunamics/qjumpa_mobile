import 'package:qjumpa/src/domain/entity/store_inventory.dart';

abstract class InventoryRepository {
  Future<List<Inventory>> getInventory(String storeId);
}
