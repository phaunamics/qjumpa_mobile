import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/domain/entity/order_entity.dart';
import 'package:qjumpa/src/domain/entity/shopping_cart_entity.dart';
import 'package:qjumpa/src/domain/usecases/get_shopping_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final getShoppingCartUsecase = sl.get<GetShoppingCartUseCase>();
  CartBloc() : super(CartInitial()) {
    on<AddToCart>((event, emit) {
      // TODO: implement add to cart logic
    });
    on<GetShoppingCart>((event, emit) async {
      emit(CartLoadingState());
      try {
        final shoppingCart =
            await getShoppingCartUsecase.call(event.userId.toString());
        emit(GetShoppingCartCompleted(shoppingCart));
      } on SocketException catch (e) {
        // TODO: Handle SocketException
        emit(CartErrorState(
            'SocketException: Failed host lookup: ${e.address}:${e.port} (${e.message})'));
      } on DioError catch (e) {
        // Handle DioError
        if (e.error is SocketException) {
          // Handle SocketException within DioError
          final socketException = e.error as SocketException;
          emit(CartErrorState(
              'DioError: SocketException: ${socketException.message}'));
        } else {
          // Handle other DioErrors
          emit(CartErrorState('DioError: ${e.message}'));
        }
      } catch (e) {
        // Handle any other exceptions
        emit(const CartErrorState('Something went wrong'));
      }
    });
  }
}
