part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}
class AddToCart extends CartEvent{
  final Order order;
  final String userId;

  const AddToCart({required this.order,required this.userId});

  @override
  List<Object> get props => [order,userId];
}
class GetShoppingCart extends CartEvent{
  final int? userId;
  const GetShoppingCart({required this.userId});

  @override
  List<Object> get props => [];
}
