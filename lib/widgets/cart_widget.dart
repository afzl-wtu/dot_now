import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_now/models/cart.dart';
import 'package:flutter/material.dart';

class CartWidget extends StatelessWidget {
  final Cart cartItem;
  const CartWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              height: 70,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      cartItem.product.pictures[0].image),
                ),
              ),
            ),
            title: Text(cartItem.product.title),
          ),
        ],
      ),
    );
  }
}
