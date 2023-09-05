import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/dio_client.dart';
import 'package:qjumpa/src/domain/entity/store_entity.dart';

abstract class GetStoreRemoteDataSource {
  Future<List<StoreEntity>> getStore();
}

class GetStoreRemoteDataSourceImpl implements GetStoreRemoteDataSource {
  final DioClient dioClient;

  GetStoreRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<List<StoreEntity>> getStore() async {
    final response = await dioClient.get(storeEndPoint);

    if (response['data'] == null) return [];
    await Future.delayed(const Duration(seconds: 5));

    return List.from(response['data'])
        .map((e) => StoreEntity.fromJson(e))
        .toList();
  }
}
