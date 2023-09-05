import 'package:qjumpa/src/domain/entity/store_entity.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';

class Arguments {
  final Inventory inventory;
  final StoreEntity? storeEntity;

  Arguments({required this.inventory, required this.storeEntity});
}
