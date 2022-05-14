import 'package:dot_now/core.dart';
import 'package:dot_now/widgets/cart_widget.dart';
import 'package:dot_now/widgets/large_round_button.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cartManger = (VxState.store as MyStore).cartManager;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xff788187)),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'My Cart',
            style: TextStyle(color: Color(0xff788187)),
          ),
          actions: [
            IconButton(
              color: const Color(0xff788187),
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: VxBuilder<MyStore>(
                  mutations: const {AddCartItemMutation},
                  builder: (_, store, __) {
                    return ListView.builder(
                      itemCount: store.cartManager.itemsInCart.length,
                      itemBuilder: (_, i) => CartWidget(
                          cartItem: store.cartManager.itemsInCart[i]),
                    );
                  }),
            ),
            Container(
              height: 130,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 15, right: 15, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sub Total:',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          '${555555}',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  const LargeRoundButton(
                      fullLength: true,
                      color: Color(0xff126881),
                      text: 'CHECK OUT'),
                  const SizedBox(
                    height: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
