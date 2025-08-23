import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsEvent {
  const LoadProducts();
}

class RefreshProducts extends ProductsEvent {
  const RefreshProducts();
}
