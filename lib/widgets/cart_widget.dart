import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_now/core.dart';
import 'package:dot_now/models/cart.dart';
import 'package:dot_now/widgets/plus_minus_button.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

class CartWidget extends StatefulWidget {
  final Cart cartItem;
  final Function() refresh;
  const CartWidget({Key? key, required this.cartItem, required this.refresh})
      : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  void _changeQuantity(int q) {
    if (widget.cartItem.product == null) return;
    setState(() {
      {
        widget.cartItem.quantity = q;
        UpdateCartItemQuantityMutation(widget.cartItem);
      }
    });
  }

  bool _isDeleteButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    final _cartManager = (VxState.store as MyStore).cartManager;
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Card(
        child: SizedBox(
            height: 164,
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
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              widget.cartItem.product == null
                                  ? 'https://cdn-icons-png.flaticon.com/128/2748/2748558.png'
                                  : widget.cartItem.product!.pictures[0].image,
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
                            widget.cartItem.product == null
                                ? 'Not Available'
                                : widget.cartItem.product!.title,
                            style: const TextStyle(
                              color: Color(0xff707578),
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Color: ${widget.cartItem.color}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 165, 162, 162),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Size: ${widget.cartItem.size}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 165, 162, 162),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Rs. ${widget.cartItem.product == null ? 0 : widget.cartItem.product!.price}',
                            style: const TextStyle(
                              color: Color(0xff707578),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                          color: Colors.red,
                          onPressed: _isDeleteButtonPressed
                              ? null
                              : () {
                                  _isDeleteButtonPressed = true;
                                  setState(() {});
                                  _cartManager
                                      .deleteCartItem(widget.cartItem)
                                      .then((value) => widget.refresh());
                                },
                          icon: const Icon(
                            Icons.delete,
                          ))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: PlusMinusButton(
                          _changeQuantity, widget.cartItem.quantity),
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
                            '${widget.cartItem.quantity * (widget.cartItem.product == null ? 0 : widget.cartItem.product!.price)}',
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
    );
  }
}
