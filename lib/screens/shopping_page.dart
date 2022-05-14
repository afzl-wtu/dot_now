import 'package:dot_now/core.dart';
import 'package:dot_now/screens/components/search_bar.dart';
import 'package:dot_now/widgets/category.dart';
import 'package:dot_now/widgets/product_tile.dart';
import 'package:flutter/material.dart';

import 'package:dot_now/widgets/login_header.dart';
import 'package:vxstate/vxstate.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _prdoductManager = (VxState.store as MyStore).productManager;
    final _categoryManager = (VxState.store as MyStore).category;
    VxState.watch(context, on: [FetchProductsMutation]);
    return Scaffold(
      backgroundColor: const Color(0xFF126881),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                LoginHeader(
                  height: 260,
                  color: const Color(0xFF0B1A2D),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 90,
                        ),
                        const Text(
                          'Categories',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categoryManager.categories.isEmpty
                                ? 6
                                : _categoryManager.categories.length,
                            itemBuilder: (_, i) =>
                                _categoryManager.categories.isEmpty
                                    ? const ShimmerCategoryPreview()
                                    : CategoryPreview(
                                        cat: _categoryManager.categories[i],
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Products',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          itemBuilder: (_, i) {
                            return _prdoductManager.products.isEmpty
                                ? const ShimmerProductTile()
                                : ProductTile(_prdoductManager.products[i]);
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: _prdoductManager.products.isEmpty
                              ? 3
                              : _prdoductManager.products.length,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          itemBuilder: (_, i) =>
                              _prdoductManager.products.isEmpty
                                  ? const ShimmerProductTile()
                                  : ProductTile(_prdoductManager.products[i]),
                          scrollDirection: Axis.horizontal,
                          itemCount: _prdoductManager.products.isEmpty
                              ? 3
                              : _prdoductManager.products.length,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SafeArea(
            child: buildFloatingSearchBar(context),
          ),
        ],
      ),
    );
  }
}
