import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:qjumpa/src/core/dio_client.dart';
import 'package:qjumpa/src/core/firebase_auth.dart';
import 'package:qjumpa/src/data/data_sources/get_inventory_remote_data_src.dart';
import 'package:qjumpa/src/data/preferences/cart_shared_preferences.dart';
import 'package:qjumpa/src/data/preferences/item_shared_preferences.dart';
import 'package:qjumpa/src/data/repositories/inventory_impl.dart';
import 'package:qjumpa/src/domain/repositories/inventory_repository.dart';
import 'package:qjumpa/src/domain/usecases/get_inventory_usecase.dart';
import 'package:qjumpa/src/presentation/paystack/bloc/payment_channel_bloc.dart';
import 'package:qjumpa/src/presentation/product_search/bloc/product_search_bloc.dart';
import 'package:qjumpa/src/presentation/store_search/bloc/barcodescanner_bloc.dart';
import 'package:qjumpa/src/presentation/store_search/bloc/ios_bar_scanner_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //firebase
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  //bloc
  sl.registerFactory<ProductSearchBloc>(() => ProductSearchBloc());
  sl.registerFactory<BarcodeScannerBloc>(() => BarcodeScannerBloc());
  sl.registerFactory<IosBarScannerBloc>(() => IosBarScannerBloc());
  sl.registerFactory<PaymentChannelBloc>(() => PaymentChannelBloc());

  // Data Sources
  sl.registerLazySingleton<GetInventoryRemoteDataSource>(
      () => GetInventoryRemoteDataSourceImpl(dioClient: sl.get()));

  //use_cases
  sl.registerLazySingleton(() => GetInventoryUseCase(sl.get()));

  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Auth>(() => Auth(sl.get()));

  //Repo
  sl.registerLazySingleton<InventoryRepository>(() => InventoryImpl(sl.get()));

  //sharedPreferences
  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());

  sl.registerLazySingleton<CartSharedPreferences>(
      () => CartSharedPreferences(sl.get()));
  sl.registerLazySingleton<ShoppingListSharedPreferences>(
      () => ShoppingListSharedPreferences(
            sl.get(),
          ));
  // sl.registerLazySingleton<ShoppingListSharedPreferences>(
  //     () => ShoppingListSharedPreferences(sl.get()));
}
