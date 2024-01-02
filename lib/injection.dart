import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:qjumpa/src/core/services/dio_client.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/data/data_sources/get_inventory_remote_data_src.dart';
import 'package:qjumpa/src/data/data_sources/get_shopping_cart_data_source.dart';
import 'package:qjumpa/src/data/data_sources/get_store_remote_data_src.dart';
import 'package:qjumpa/src/data/local_storage/cart_shared_preferences.dart';
import 'package:qjumpa/src/data/local_storage/item_shared_preferences.dart';
import 'package:qjumpa/src/data/repositories/get_store_impl.dart';
import 'package:qjumpa/src/data/repositories/inventory_impl.dart';
import 'package:qjumpa/src/data/repositories/shopping_cart_impl.dart';
import 'package:qjumpa/src/domain/repositories/inventory_repository.dart';
import 'package:qjumpa/src/domain/repositories/shopping_cart_repository.dart';
import 'package:qjumpa/src/domain/repositories/store_repository.dart';
import 'package:qjumpa/src/domain/usecases/get_inventory_usecase.dart';
import 'package:qjumpa/src/domain/usecases/get_shopping_cart_usecase.dart';
import 'package:qjumpa/src/domain/usecases/get_store_usecase.dart';
import 'package:qjumpa/src/presentation/login/bloc/login_user_bloc.dart';
import 'package:qjumpa/src/presentation/product_scan/bloc/barcodescanner_bloc.dart';
import 'package:qjumpa/src/presentation/product_scan/bloc/ios_bar_scanner_bloc.dart';
import 'package:qjumpa/src/presentation/product_search/bloc/product_search_bloc.dart';
import 'package:qjumpa/src/presentation/register_user/bloc/register_user_bloc.dart';
import 'package:qjumpa/src/presentation/shopping_cart/bloc/cart_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Auth
  sl.registerLazySingleton<UserAuthService>(
    () => UserAuthService(),
  );

  //bloc
  sl.registerFactory<ProductSearchBloc>(() => ProductSearchBloc());
  sl.registerFactory<BarcodeScannerBloc>(() => BarcodeScannerBloc());
  sl.registerFactory<IosBarScannerBloc>(() => IosBarScannerBloc());
  sl.registerFactory<RegisterUserBloc>(() => RegisterUserBloc());
  sl.registerFactory<LoginUserBloc>(() => LoginUserBloc());
  sl.registerFactory<CartBloc>(() => CartBloc());

  // Data Sources
  sl.registerLazySingleton<GetInventoryRemoteDataSource>(
      () => GetInventoryRemoteDataSourceImpl(dioClient: sl.get()));
  sl.registerLazySingleton<GetStoreRemoteDataSource>(
      () => GetStoreRemoteDataSourceImpl(dioClient: sl.get()));
  sl.registerLazySingleton<GetShoppingCartRemoteDataSource>(
      () => GetShoppingCartRemoteDataSourceImpl(userAuthService: sl.get()));

  //use_cases
  sl.registerLazySingleton(() => GetInventoryUseCase(sl.get()));
  sl.registerLazySingleton(() => GetStoreUseCase(sl.get()));
  sl.registerLazySingleton(() => GetShoppingCartUseCase(sl.get()));

  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton(() => InternetConnectionChecker());

  //Repository
  sl.registerLazySingleton<InventoryRepository>(() => InventoryImpl(sl.get()));
  sl.registerLazySingleton<StoreRepository>(() => GetStoreImpl(sl.get()));
  sl.registerLazySingleton<ShoppingCartRepository>(
      () => ShoppingCartImpl(sl.get()));

  //sharedPreferences
  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());
  sl.registerLazySingleton<CartSharedPreferences>(
      () => CartSharedPreferences(sl.get()));
  sl.registerLazySingleton<ShoppingListSharedPreferences>(
    () => ShoppingListSharedPreferences(
      sl.get(),
    ),
  );
}
