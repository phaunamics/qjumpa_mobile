import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/dio_client.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';

abstract class GetInventoryRemoteDataSource {
  Future<List<Inventory>> getStoreInventory();
}

class GetInventoryRemoteDataSourceImpl implements GetInventoryRemoteDataSource {
  final DioClient dioClient;

  GetInventoryRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<List<Inventory>> getStoreInventory() async {
    final response = await dioClient.get(inventoryEndpoint);

    if (response['data'] == null) return [];
    return List.from(response['data'])
        .map((e) => Inventory.fromJson(e))
        .toList();
  }
}
