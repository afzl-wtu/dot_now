import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_now/models/product.dart';
import 'package:dot_now/screens/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  const ProductTile(this.product, {Key? key}) : super(key: key);

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool _isFaviourite = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(widget.product),
            ),
          ),
          child: Stack(
            children: [
              SizedBox(
                height: 220,
                width: 130,
                child: GridTile(
                  child: CachedNetworkImage(
                    imageUrl: widget.product.pictures[0].image,
                    placeholder: (_, __) => _shimmerGridTile(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                child: FittedBox(
                  child: Text(
                    '  ${widget.product.title}',
                    style: const TextStyle(
                      color: Color(0xFFF36616),
                    ),
                  ),
                ),
                bottom: 30,
              ),
              Positioned(
                bottom: 10,
                child: FittedBox(
                    child: Text(
                  '  Rs. ${widget.product.price}',
                  style: const TextStyle(
                    color: Color(0xFFF36616),
                  ),
                )),
              ),
              Positioned(
                bottom: -4,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isFaviourite = !_isFaviourite;
                      });
                    },
                    icon: Icon(
                      _isFaviourite ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFFF36616),
                    )),
              ),
              Positioned(
                right: 15,
                top: -1,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 40,
                      child: SvgPicture.asset(
                        'assets/svg/discount banner.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      '  Disc \n  ${widget.product.sale}%',
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerProductTile extends StatelessWidget {
  const ShimmerProductTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            _shimmerGridTile(),
            Positioned(
              child: _buildShimmerContainer(50),
              bottom: 30,
            ),
            Positioned(bottom: 10, child: _buildShimmerContainer(70)),
            Positioned(
              bottom: -4,
              right: 0,
              child: IconButton(
                  onPressed: () {},
                  icon: Shimmer.fromColors(
                    baseColor: const Color(0xFF7a330b),
                    highlightColor: const Color(0xfff4752d),
                    child: const Icon(
                      Icons.favorite,
                      color: Color(0xFFF36616),
                    ),
                  )),
            ),
            Positioned(
              right: 15,
              top: -1,
              child: SizedBox(
                height: 50,
                width: 40,
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFF7a330b),
                  highlightColor: const Color(0xfff4752d),
                  child: SvgPicture.asset(
                    'assets/svg/discount banner.svg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer(double width, [double height = 12]) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF7a330b),
        highlightColor: const Color(0xfff4752d),
        child: Container(
          color: Colors.black,
          height: height,
          width: width,
        ),
      ),
    );
  }
}

Shimmer _shimmerGridTile() {
  return Shimmer.fromColors(
    baseColor: const Color(0xFF051f27),
    highlightColor: const Color(0xff41869a),
    child: SizedBox(
      height: 220,
      width: 130,
      child: GridTile(
          child: Container(
        color: Colors.pink,
        width: double.infinity,
        height: double.infinity,
      )),
    ),
  );
}
