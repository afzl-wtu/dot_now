import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_now/models/product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vxstate/vxstate.dart';

import '../core.dart';

class CartManger {
  final List<Cart> _itemsInCart = [];
  List<Cart> get itemsInCart => _itemsInCart;
  final _databaseRef = FirebaseDatabase.instance;
  final _fireStoreRef = FirebaseFirestore.instance.collection('products');
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
      _itemsInCart.add(
        Cart.fromMap(
          {
            'id': key,
            'color': value['color'],
            'size': value['size'],
            'quantity': value['quantity'],
            'productId': value['productId'],
          },
        ),
      );
    });
    int i = 0;
    await Future.forEach(_itemsInCart, (Cart element) async {
      final _a = await _fireStoreRef.doc(element.productId).get();
      if (!_a.exists) {
        i++;
        return;
      }
      final _b = Product.fromMap(_a.data()!);
      _itemsInCart[i] = element.copyWith(product: _b);
      i++;
    });
  }

  Future<void> updateQuantity(Cart item) async {
    await _databaseRef
        .ref('users/+92333 3333333/cart')
        .child(item.id.toString())
        .update({'quantity': item.quantity});
    _itemsInCart[_itemsInCart.indexWhere((element) => element.id == item.id)]
        .quantity = item.quantity;
  }

  Future<void> addCartItem(Cart item) async {
    final _oldIndex = _itemsInCart.indexWhere((e) =>
        (e.productId == item.productId &&
            e.color == item.color &&
            e.size == item.size));
    if (_oldIndex != -1) {
      final _oldQuantity = _itemsInCart[_oldIndex].quantity;
      final _a = _itemsInCart[_oldIndex]
          .copyWith(quantity: _oldQuantity + item.quantity);
      UpdateCartItemQuantityMutation(_a);
      return;
    }
    await _databaseRef
        .ref('users/+92333 3333333/cart')
        .child(item.id.toString())
        .set(item.toMap());
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
  final String productId;
  Product? product;
  int quantity;
  final String? size;
  final String color;
  final int id;

  Cart(
      {required this.id,
      required this.productId,
      required this.quantity,
      this.size,
      this.product,
      required this.color});

  Cart copyWith({
    String? productId,
    Product? product,
    int? quantity,
    String? size,
    String? color,
    int? id,
  }) {
    return Cart(
      productId: productId ?? this.productId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      color: color ?? this.color,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'productId': productId});
    result.addAll({'quantity': quantity});
    if (size != null) {
      result.addAll({'size': size});
    }
    result.addAll({'color': color});
    result.addAll({'id': id});

    return result;
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      productId: map['productId'],
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
    return 'Cart(productId: $productId, quantity: $quantity, size: $size, color: $color, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart &&
        other.productId == productId &&
        other.quantity == quantity &&
        other.size == size &&
        other.color == color &&
        other.id == id;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        quantity.hashCode ^
        size.hashCode ^
        color.hashCode ^
        id.hashCode;
  }
}

class UpdateCartItemQuantityMutation extends VxMutation<MyStore> {
  final Cart cartItem;
  UpdateCartItemQuantityMutation(this.cartItem);
  @override
  Future<void> perform() async {
    store!.loading = true;
    await store!.cartManager.updateQuantity(cartItem);
  }
}
