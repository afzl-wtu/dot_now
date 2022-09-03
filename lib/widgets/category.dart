import 'package:dot_now/core.dart';
import 'package:dot_now/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CategoryPreview extends StatelessWidget {
  final Category cat;
  const CategoryPreview({
    Key? key,
    required this.cat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => cat.title == 'ALL'
          ? FetchProductsMutation()
          : FetchProductsMutation(cat),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 70,
                width: 70,
                color: Colors.white,
                child: SvgPicture.string(
                    cat.image), //SvgPicture.network(cat.image),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            cat.title,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class ShimmerCategoryPreview extends StatelessWidget {
  const ShimmerCategoryPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Shimmer.fromColors(
                baseColor: const Color(0xFF051f27),
                highlightColor: const Color(0xff41869a),
                child: Container(
                  height: 70,
                  width: 70,
                  color: Colors.white,
                ),
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        Shimmer.fromColors(
          baseColor: const Color(0xFF7a330b),
          highlightColor: const Color(0xfff4752d),
          child: Container(
            height: 8,
            width: 40,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
