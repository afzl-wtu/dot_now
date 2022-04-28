import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_now/core.dart';
import 'package:dot_now/models/cart.dart';
import 'package:dot_now/widgets/plus_minus_button.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

class CartWidget extends StatefulWidget {
  final Cart cartItem;
  const CartWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  void _changeQuantity(int q) {
    setState(() {
      widget.cartItem.quantity = q;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _cartManager = (VxState.store as MyStore).cartManager;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Dismissible(
        onDismissed: (direction) =>
            _cartManager.deleteCartItem(widget.cartItem),
        background: Container(color: Colors.red),
        key: Key(widget.cartItem.id.toString()),
        child: Card(
          child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 135,
                          width: 135,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                widget.cartItem.product.pictures[0].image,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cartItem.product.title,
                              style: const TextStyle(
                                color: Color(0xff707578),
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Color: ${widget.cartItem.color}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 165, 162, 162),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Size: ${widget.cartItem.size}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 165, 162, 162),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Rs. ${widget.cartItem.product.price}',
                              style: const TextStyle(
                                color: Color(0xff707578),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: PlusMinusButton(_changeQuantity),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 165, 162, 162)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Rs. ',
                              style: TextStyle(
                                color: Color(0xFFF36616),
                              ),
                            ),
                            Text(
                              '${widget.cartItem.quantity * widget.cartItem.product.price}',
                              style: const TextStyle(
                                  color: Color(0xFFF36616), fontSize: 22),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
