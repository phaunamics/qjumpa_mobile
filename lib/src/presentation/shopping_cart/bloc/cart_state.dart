part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class AddToCartSuccessful extends CartState {}

class AddToCartFailed extends CartState {}

class CartLoadingState extends CartState {}

class GetShoppingCartCompleted extends CartState {
  final ShoppingCartEntity? shoppingCartEntity;

  const GetShoppingCartCompleted(this.shoppingCartEntity);
}

class CartInitial extends CartState {}
class CartErrorState extends CartState{
  final String message;

  const CartErrorState(this.message);
  @override
  List<Object> get props => [message];
}
