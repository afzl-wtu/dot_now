import 'dart:convert';

import 'package:dot_now/models/product.dart';
import 'package:firebase_database/firebase_database.dart';

class CartManger {
  final List<Cart> _itemsInCart = [];
  List<Cart> get itemsInCart => _itemsInCart;
  final _databaseRef = FirebaseDatabase.instance;
  CartManger() {
    fetchCartItems();
  }
  Future<void> fetchCartItems() async {
    final _snap = await _databaseRef
        .ref('users/+92333 3333333/cart')
        .ref
        .orderByKey()
        .get();
    if (_snap.value == null) {
      throw Exception('Cart Not Found');
    }
    final Map cart = _snap.value as Map;
    _itemsInCart.clear();
    cart.forEach((key, value) {
      // product: Product.fromMap(map['product']),
      // quantity: map['quantity']?.toInt() ?? 0,
      // size: map['size'],
      // color: map['color'] ?? '',
      // id: map['id']?.toInt() ?? 0,
      _itemsInCart.add(
        Cart.fromMap(
          {
            'id': key,
            'color': value['color'],
            'size': value['size'],
            'quantity': value['quantity'],
            'product': value['product'],
          },
        ),
      );
    });
  }

  Future<void> addCartItem(Cart item) async {
    await _databaseRef
        .ref('users/+92333 3333333/cart')
        .child(item.id.toString())
        .set(item.toMap().remove('id'));
    // if (catToUpdate != null) {
    //   _categories.remove(catToUpdate);
    // }
    _itemsInCart.add(item);
  }

  Future<void> deleteCartItem(
    Cart item,
  ) async {
    await _databaseRef
        .ref('users/+92333 3333333/cart')
        .child(item.id.toString())
        .remove();
    _itemsInCart.remove(item);
  }
}

class Cart {
  final Product product;
  final int quantity;
  final String? size;
  final String color;
  final int id;

  Cart(
      {required this.id,
      required this.product,
      required this.quantity,
      this.size,
      required this.color});

  Cart copyWith({
    Product? product,
    int? quantity,
    String? size,
    String? color,
    int? id,
  }) {
    return Cart(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      color: color ?? this.color,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'product': product.toMap()});
    result.addAll({'quantity': quantity});
    if (size != null) {
      result.addAll({'size': size});
    }
    result.addAll({'color': color});
    result.addAll({'id': id});

    return result;
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    final productMap = Map<String, dynamic>.from(map['product']);
    return Cart(
      product: Product.fromMap(productMap),
      quantity: map['quantity'],
      size: map['size'],
      color: map['color'] ?? '',
      id: int.parse(map['id']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(product: $product, quantity: $quantity, size: $size, color: $color, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart &&
        other.product == product &&
        other.quantity == quantity &&
        other.size == size &&
        other.color == color &&
        other.id == id;
  }

  @override
  int get hashCode {
    return product.hashCode ^
        quantity.hashCode ^
        size.hashCode ^
        color.hashCode ^
        id.hashCode;
  }
}
