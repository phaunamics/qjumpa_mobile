import 'package:qjumpa/src/data/data_sources/get_store_remote_data_src.dart';
import 'package:qjumpa/src/domain/entity/store_entity.dart';
import 'package:qjumpa/src/domain/repositories/store_repository.dart';

class GetStoreImpl implements StoreRepository {
  final GetStoreRemoteDataSource getStoreRemoteDataSource;

  GetStoreImpl(this.getStoreRemoteDataSource);

  @override
  Future<List<StoreEntity>> getStore() {
    return getStoreRemoteDataSource.getStore();
  }
}
