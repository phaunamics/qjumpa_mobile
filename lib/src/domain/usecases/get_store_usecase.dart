import 'package:qjumpa/src/core/utils/usecase.dart';
import 'package:qjumpa/src/domain/entity/store_entity.dart';
import 'package:qjumpa/src/domain/repositories/store_repository.dart';

class GetStoreUseCase extends UseCase<List<StoreEntity>, NoParams> {
  final StoreRepository storeRepository;

  GetStoreUseCase(this.storeRepository);

  @override
  Future<List<StoreEntity>> call(NoParams params) async {
    return await storeRepository.getStore();
  }
}
