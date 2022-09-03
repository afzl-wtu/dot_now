import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dot_now/core.dart';
import 'package:dot_now/models/cart.dart';
import 'package:dot_now/widgets/large_round_button.dart';
import 'package:dot_now/widgets/plus_minus_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:vxstate/vxstate.dart';

import '../models/product.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage(this.product, {Key? key}) : super(key: key);
  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _controller = CarouselController();
  var _current = 0;
  var _rating = 4.5;
  int _quantity = 1;
  var _addingToCart = false;
  var _addingToCartFirstTime = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  void _changeQuantity(int q) {
    _quantity = q;
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: 400.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                      items: widget.product.pictures
                          .map(
                            (e) => CachedNetworkImage(
                              imageUrl: e.image,
                              fit: BoxFit.cover,
                            ),
                          )
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFFF36616),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const CartPage())),
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Color(0xFFF36616),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 15,
                      right: 20,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_outline,
                          size: 36,
                          color: Color(0xFFF36616),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.product.pictures.asMap().entries.map(
                      (entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                ListTile(
                  title: Text(
                    widget.product.title,
                    style: const TextStyle(fontSize: 22),
                  ),
                  subtitle: SmoothStarRating(
                      allowHalfRating: true,
                      onRatingChanged: (v) {
                        _rating = v;
                        setState(() {});
                      },
                      starCount: 5,
                      rating: _rating,
                      defaultIconData: Icons.star_border,
                      size: 18.0,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      color: const Color(0xFFF36616),
                      borderColor: const Color(0xFFF36616),
                      spacing: 0.0),
                  trailing: Text(
                    'Rs. ${widget.product.price}',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('      Size'),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        children: ['S', 'M', 'L', 'XL']
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: const Color(0xFFF6F6F7),
                                    height: 30,
                                    width: 30,
                                    child: Text(e),
                                  ),
                                ))
                            .toList())
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('      Color'),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.product.pictures
                          .toSet()
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  color:
                                      widget.product.pictures[_current].color ==
                                              e.color
                                          ? const Color(0xFFF36616)
                                          : const Color(0xFFF6F6F7),
                                  height: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(e.color),
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('      Quantity'),
                    PlusMinusButton(_changeQuantity, 1),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ReadMoreText(
                        widget.product.description,
                        style: const TextStyle(
                          color: Color(0xffACB8C1),
                        ),
                        trimLines: 2,
                        colorClickableText: const Color(0xFFF36616),
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read more',
                        trimExpandedText: 'Show less',
                        moreStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF36616)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const LargeRoundButton(
                                color: Color(0xFFF36616), text: 'Search Local'),
                            InkWell(
                              onTap: _addingToCart
                                  ? null
                                  : () {
                                      AddCartItemMutation(
                                        Cart(
                                          id: DateTime.now()
                                              .microsecondsSinceEpoch,
                                          color: widget
                                              .product.pictures[_current].color,
                                          productId: widget.product.id,
                                          product: widget.product,
                                          size: 'S',
                                          quantity: _quantity,
                                        ),
                                      );
                                      _addingToCart = true;
                                    },
                              child: VxBuilder<MyStore>(
                                mutations: const {
                                  AddCartItemMutation,
                                },
                                builder: (_, store, __) {
                                  print(
                                      'PP: In VxBuilder: _addingToCart: $_addingToCart, _addingToCartFirstTime: $_addingToCartFirstTime');

                                  print(
                                      'PP: before actual Widget: _addingToCart: $_addingToCart');
                                  return _addingToCart
                                      ? Builder(builder: (context) {
                                          if (_addingToCart &&
                                              !_addingToCartFirstTime) {
                                            _addingToCartFirstTime = true;
                                          }
                                          if (_addingToCart &&
                                              _addingToCartFirstTime) {
                                            _addingToCartFirstTime = false;
                                            _addingToCart = false;
                                          }
                                          return const Padding(
                                            padding:
                                                EdgeInsets.only(right: 40.0),
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                color: Color(0xFFF36616),
                                              ),
                                            ),
                                          );
                                        })
                                      : const LargeRoundButton(
                                          color: Color(0xFFF36616),
                                          text: 'Add to Cart');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
