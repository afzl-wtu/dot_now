import 'package:dot_now/core.dart';
import 'package:dot_now/widgets/cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cart = (VxState.store as MyStore).cartManager;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('My Cart'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _cart.itemsInCart.length,
        itemBuilder: (_, i) => CartWidget(cartItem: _cart.itemsInCart[i]),
      ),
    );
  }
}
