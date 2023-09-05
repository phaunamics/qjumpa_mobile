import 'package:qjumpa/src/domain/entity/store_entity.dart';

abstract class StoreRepository {
  Future<List<StoreEntity>> getStore();
}
