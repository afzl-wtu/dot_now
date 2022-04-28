import 'package:dot_now/core.dart';
import 'package:dot_now/screens/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:vxstate/vxstate.dart';

Widget buildFloatingSearchBar(BuildContext context) {
  return FloatingSearchBar(
    borderRadius: BorderRadius.circular(8),
    automaticallyImplyBackButton: true,
    actions: [
      FloatingSearchBarAction.searchToClear(),
      FloatingSearchBarAction(
        showIfClosed: true,
        showIfOpened: false,
        child: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const CartPage()));
          },
          icon: const Icon(Icons.shopping_cart),
        ),
      )
    ],
    onQueryChanged: (query) {
      FetchSearchResultMutation(query);
    },
    backdropColor: Colors.transparent,
    elevation: 0,
    builder: (_, __) => Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      height: 400,
      child: VxBuilder<MyStore>(
        mutations: const {FetchSearchResultMutation},
        builder: (_, store, ___) {
          final _list = store.productManager.searchResults;
          return ListView.builder(
              itemCount: _list.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(store.productManager.searchResults[i].title),
                );
              });
        },
      ),
    ),
  );
}
