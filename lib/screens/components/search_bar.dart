import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

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
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart),
        ),
      )
    ],
    backdropColor: Colors.transparent,
    elevation: 0,
    builder: (_, __) => Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      height: 400,
    ),
  );
}
