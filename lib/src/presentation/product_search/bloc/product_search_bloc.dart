import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/domain/usecases/get_inventory_usecase.dart';

part 'product_search_event.dart';
part 'product_search_state.dart';

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  List<Inventory>? _searchResults = [];
  final getInventoryUseCase = sl.get<GetInventoryUseCase>();
  List<Inventory>? _cachedInventory;

  void performItemNameSearch(
      {required String value, required List<Inventory>? inventory}) {
    if (value.isNotEmpty) {
      _searchResults = inventory
          ?.where(
              (item) => item.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      // print('search is $_searchResults');
    } else {
      _searchResults!.clear();
      // print('on clear $_searchResults');
    }
  }

  ProductSearchBloc() : super(ProductSearchInitial()) {
    on<Search>((event, emit) async {
      emit(ProductSearchingState());
      if (_cachedInventory != null) {
        performItemNameSearch(value: event.query, inventory: _cachedInventory);
        emit(ProductSearchCompletedState(inventory: _searchResults));
      } else {
        try {
          final inventory = await getInventoryUseCase.call(event.storeId);
          _cachedInventory = inventory;
          performItemNameSearch(value: event.query, inventory: inventory);
          emit(ProductSearchCompletedState(inventory: _searchResults));
        } on SocketException catch (e) {
          // TODO: Handle SocketException
          emit(ErrorState(
              'SocketException: Failed host lookup: ${e.address}:${e.port} (${e.message})'));
        } on DioError catch (e) {
          // Handle DioError
          if (e.error is SocketException) {
            // Handle SocketException within DioError
            final socketException = e.error as SocketException;
            emit(ErrorState(
                'DioError: SocketException: ${socketException.message}'));
          } else {
            // Handle other DioErrors
            emit(ErrorState('DioError: ${e.message}'));
          }
        } catch (e) {
          // Handle any other exceptions
          emit(const ErrorState('Something went wrong'));
        }
      }
    });
  }
}
