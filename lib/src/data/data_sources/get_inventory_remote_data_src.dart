import 'package:qjumpa/src/core/services/dio_client.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';

abstract class GetInventoryRemoteDataSource {
  Future<List<Inventory>> getStoreInventory(String id);
}

class GetInventoryRemoteDataSourceImpl implements GetInventoryRemoteDataSource {
  final DioClient dioClient;

  GetInventoryRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<Inventory>> getStoreInventory(String id) async {
    final response = await dioClient.getListOfStores(inventoryEndpoint(id));

    if (response['data'] == null) return [];

    final List<dynamic> inventoryData = response['data']['products'];

    if (inventoryData.isEmpty) return [];

    final List<Inventory> inventoryList =
        inventoryData.map((e) => Inventory.fromJson(e)).toList();

    return inventoryList;
  }
}
