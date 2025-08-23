import 'package:equatable/equatable.dart';
import 'cart_product.dart';

class Cart extends Equatable {
  final int id;
  final int userId;
  final DateTime date;
  final List<CartProduct> products;

  const Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  @override
  List<Object> get props => [id, userId, date, products];
}
