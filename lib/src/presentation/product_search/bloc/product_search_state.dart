part of 'product_search_bloc.dart';

abstract class ProductSearchState extends Equatable {
  const ProductSearchState();

  @override
  List<Object> get props => [];
}

class ProductSearchInitial extends ProductSearchState {}

class ProductSearchingState extends ProductSearchState {
  @override
  List<Object> get props => [];
}

class ProductSearchCompletedState extends ProductSearchState {
  final List<Inventory>? inventory;

  const ProductSearchCompletedState({required this.inventory});

  @override
  List<Object> get props => [];
}

class ErrorState extends ProductSearchState {
  final String message;

  const ErrorState(this.message);
  @override
  List<Object> get props => [];
}
