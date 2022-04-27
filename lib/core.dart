import 'package:dot_now/models/auth.dart';
import 'package:dot_now/models/cart.dart';
import 'package:dot_now/models/category.dart';
import 'package:dot_now/models/product.dart';
import 'package:vxstate/vxstate.dart';

class MyStore extends VxStore {
  final auth = AuthModel();
  final productManager = ProductMnager();
  final category = CategoryManager();
  final cartManager = CartManger();
  bool loading = false;
}

class FetchProductsMutation extends VxMutation<MyStore> {
  final Category? category;

  FetchProductsMutation([this.category]);
  @override
  Future<void> perform() async {
    await store!.productManager.fetchProducts(category);
  }
}

class FetchSearchResultMutation extends VxMutation<MyStore> {
  final String query;

  FetchSearchResultMutation(this.query);

  @override
  Future<void> perform() async {
    await store!.productManager.fetchPSearchResults(query);
  }
}

class AddCartItemMutation extends VxMutation<MyStore> {
  final Cart cartItem;
  AddCartItemMutation(this.cartItem);
  @override
  Future<void> perform() async {
    store!.loading = true;
    await store!.cartManager.addCartItem(cartItem);
    AddedCartItemMutation();
  }
}

class AddedCartItemMutation extends VxMutation<MyStore> {
  @override
  void perform() {
    store!.loading = false;
  }
}
