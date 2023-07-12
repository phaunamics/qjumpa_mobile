part of 'product_search_bloc.dart';

abstract class ProductSearchEvent extends Equatable {
  const ProductSearchEvent();

  @override
  List<Object> get props => [];
}

class Search extends ProductSearchEvent {
  final String query;
  final List<Inventory>? inventory;

  const Search(this.query, this.inventory);

  @override
  List<Object> get props => [query];
}
