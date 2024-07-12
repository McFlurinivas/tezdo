import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tezdo/model/products.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromDocument(DocumentSnapshot doc) {
    return CartItem(
      product: Product.fromDocument(doc),
      quantity: doc['quantity'] ?? 1, 
    );
  }
}
