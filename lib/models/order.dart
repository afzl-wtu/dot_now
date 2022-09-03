import 'dart:convert';

import 'package:collection/collection.dart';

import 'cart.dart';

class Order {
  final int id;
  final int subtotalForProducts;
  final int deliveryCharges;
  final String userName;
  final String address;
  final String description;
  final String paymentMethod;
  final List<Cart> items;
  final bool sendAsDropShipper;

  Order(
      {required this.id,
      required this.subtotalForProducts,
      required this.deliveryCharges,
      required this.userName,
      required this.address,
      this.description = '',
      this.paymentMethod = 'Payment On Delivery',
      required this.items,
      this.sendAsDropShipper = false});

  Order copyWith({
    int? id,
    int? subtotalForProducts,
    int? deliveryCharges,
    String? userName,
    String? address,
    String? description,
    String? paymentMethod,
    List<Cart>? items,
    bool? sendAsDropShipper,
  }) {
    return Order(
      id: id ?? this.id,
      subtotalForProducts: subtotalForProducts ?? this.subtotalForProducts,
      deliveryCharges: deliveryCharges ?? this.deliveryCharges,
      userName: userName ?? this.userName,
      address: address ?? this.address,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      items: items ?? this.items,
      sendAsDropShipper: sendAsDropShipper ?? this.sendAsDropShipper,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'subtotalForProducts': subtotalForProducts});
    result.addAll({'deliveryCharges': deliveryCharges});
    result.addAll({'userName': userName});
    result.addAll({'address': address});
    result.addAll({'description': description});
    result.addAll({'paymentMethod': paymentMethod});
    result.addAll({'items': items.map((x) => x.toMap()).toList()});
    result.addAll({'sendAsDropShipper': sendAsDropShipper});

    return result;
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toInt() ?? 0,
      subtotalForProducts: map['subtotalForProducts']?.toInt() ?? 0,
      deliveryCharges: map['deliveryCharges']?.toInt() ?? 0,
      userName: map['userName'] ?? '',
      address: map['address'] ?? '',
      description: map['description'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      items: List<Cart>.from(map['items']?.map((x) => Cart.fromMap(x))),
      sendAsDropShipper: map['sendAsDropShipper'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(id: $id, subtotalForProducts: $subtotalForProducts, deliveryCharges: $deliveryCharges, userName: $userName, address: $address, description: $description, paymentMethod: $paymentMethod, items: $items, sendAsDropShipper: $sendAsDropShipper)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Order &&
        other.id == id &&
        other.subtotalForProducts == subtotalForProducts &&
        other.deliveryCharges == deliveryCharges &&
        other.userName == userName &&
        other.address == address &&
        other.description == description &&
        other.paymentMethod == paymentMethod &&
        listEquals(other.items, items) &&
        other.sendAsDropShipper == sendAsDropShipper;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        subtotalForProducts.hashCode ^
        deliveryCharges.hashCode ^
        userName.hashCode ^
        address.hashCode ^
        description.hashCode ^
        paymentMethod.hashCode ^
        items.hashCode ^
        sendAsDropShipper.hashCode;
  }
}
