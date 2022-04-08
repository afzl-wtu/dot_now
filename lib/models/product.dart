import 'package:flutter/widgets.dart';

class Product {
  final String id, title, description;
  List<ColorImage> pictures;
  final Category category;
  final String sellerNumber;
  final String sellerName;
  final String sellerStoreName;
  bool isFav;
  final int sale, price;

  Product({
    required this.sellerNumber,
    required this.sellerName,
    required this.sellerStoreName,
    required this.id,
    required this.title,
    required this.pictures,
    required this.category,
    required this.description,
    this.isFav = false,
    required this.price,
    required this.sale,
  });
}

class ColorImage {
  final String image;
  final Color color;

  ColorImage({required this.image, required this.color});
}

class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });
}
