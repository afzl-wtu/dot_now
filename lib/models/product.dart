import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show listEquals;

import 'category.dart';

class ProductMnager {
  ProductMnager() {
    fetchProducts();
    fetchColors();
  }
  List<Product> _products = [];
  final List<String> _productImages = [];
  final List<String> _productImagesFirebaseNames = [];
  List<String> _productColors = [];
  List<Product> searchResults = [];

  final _fireStoreRef = FirebaseFirestore.instance.collection('products');
  final _storageRef = FirebaseStorage.instance.ref('products');
  final _databaseRef = FirebaseDatabase.instance;

  List<Product> get products => _products;
  Future<void> fetchPSearchResults(String query) async {
    final _a =
        await _fireStoreRef.where('title', isGreaterThanOrEqualTo: query).get();

    if (_a.docs.isEmpty) {
      searchResults = [];
      return;
    }
    searchResults = _a.docs.map((e) {
      final _a = Product.fromMap(e.data()).copyWith(id: e.id);

      return _a;
    }).toList();
  }

  Future<void> fetchProducts([Category? category]) async {
    QuerySnapshot<Map<String, dynamic>>? _a;
    if (category != null) {
      _a = await _fireStoreRef
          .where('category', isEqualTo: {'title': category.title}).get();
    } else {
      _a = await _fireStoreRef.get();
    }
    if (_a.docs.isEmpty) {
      _products = [];
      return;
    }
    _products = _a.docs.map((e) {
      final _a = Product.fromMap(e.data()).copyWith(id: e.id);

      return _a;
    }).toList();
  }

  List<String> get productColors => _productColors;

  Future<void> fetchColors() async {
    if (_productColors.isNotEmpty) return;
    final _response = await _databaseRef.ref('productColors').get();
    if (!_response.exists) return;
    _productColors = (_response.value as List).sublist(1).cast<String>();
  }

  Future<void> addProduct(Product product, {String? id}) async {
    final List<ColorImage> _a = [];
    final List<ColorImage> _b = [];
    //FOrLoop not working here oddly.
    // for (int i = 0; i > _productImages.length; i++) {
    //   print('PP: In ForLoop');
    //   final _b = product.pictures[i].copyWith(
    //     image: _productImages[i],
    //     firebaseName: _productImagesFirebaseNames[i],
    //   );
    //   _a.add(_b);
    // }

    //So using alternative.
    int i = 0;
    int j = 0;
    for (var element in product.pictures) {
      if (element.image.isEmpty && j < _productImages.length) {
        final _b = product.pictures[i].copyWith(
          image: _productImages[j],
          firebaseName: _productImagesFirebaseNames[j],
        );
        _a.add(_b);
        j++;
      }
      if (element.image.isNotEmpty) {
        _b.add(element);
      }
      i++;
    }
    final _c = [..._b, ..._a];

    final _semiFinalProduct = product.copyWith(pictures: _c);
    if (id != null) {
      await _fireStoreRef.doc(id).update(_semiFinalProduct.toMap());
      _products.removeWhere((element) => element.id == id);
      _products.add(_semiFinalProduct);
    } else {
      final _response = await _fireStoreRef.add(_semiFinalProduct.toMap());
      _products.add(_semiFinalProduct.copyWith(id: _response.id));
    }
    _productImages.clear();
    _productImagesFirebaseNames.clear();
  }

  Future<void> deletePhotoOnly(String url) async {
    await _storageRef.child(url).delete();
  }

  Future<void> deleteProduct(Product prod) async {
    for (var element in prod.pictures) {
      await _storageRef.child(element.firebaseName!).delete();
    }
    await _fireStoreRef.doc(prod.id).delete();
    _products.remove(prod);
  }

  Future<void> uploadImage(File file) async {
    final _imageName = 'DotNow ${DateTime.now().microsecondsSinceEpoch}.jpg';
    final reference = _storageRef.child(_imageName);
    final uploadTask = reference.putFile(file);
    final downloadUrl = await uploadTask.whenComplete(() => null);
    String _url = await downloadUrl.ref.getDownloadURL();
    _productImagesFirebaseNames.add(_imageName);
    _productImages.add(_url);
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  List<ColorImage> pictures;
  final Category category;
  final String sellerNumber;
  final String sellerName;
  final String sellerStoreName;
  int? quantity;
  bool isFav;
  final int sale;
  final int price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    this.quantity,
    required this.pictures,
    required this.category,
    required this.sellerNumber,
    required this.sellerName,
    required this.sellerStoreName,
    this.isFav = false,
    required this.sale,
    required this.price,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    List<ColorImage>? pictures,
    Category? category,
    String? sellerNumber,
    String? sellerName,
    String? sellerStoreName,
    bool? isFav,
    int? sale,
    int? price,
    int? quantity,
  }) {
    return Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        pictures: pictures ?? this.pictures,
        category: category ?? this.category,
        sellerNumber: sellerNumber ?? this.sellerNumber,
        sellerName: sellerName ?? this.sellerName,
        sellerStoreName: sellerStoreName ?? this.sellerStoreName,
        isFav: isFav ?? this.isFav,
        sale: sale ?? this.sale,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'pictures': pictures.map((x) => x.toMap()).toList()});
    result.addAll({'category': category.toMap()});
    result.addAll({'sellerNumber': sellerNumber});
    result.addAll({'sellerName': sellerName});
    result.addAll({'sellerStoreName': sellerStoreName});
    result.addAll({'isFav': isFav});
    result.addAll({'sale': sale});
    result.addAll({'price': price});
    result.addAll({'quantity': quantity});

    return result;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      pictures: List<ColorImage>.from(map['pictures']?.map((x) {
        final newMap = Map<String, dynamic>.from(x);
        return ColorImage.fromMap(newMap);
      })),
      category: Category.fromMap(Map<String, dynamic>.from(map['category'])),
      sellerNumber: map['sellerNumber'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerStoreName: map['sellerStoreName'] ?? '',
      isFav: map['isFav'] ?? false,
      sale: map['sale']?.toInt() ?? 0,
      price: map['price']?.toInt() ?? 0,
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, pictures: $pictures, category: $category, sellerNumber: $sellerNumber, sellerName: $sellerName, sellerStoreName: $sellerStoreName, isFav: $isFav, sale: $sale, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        listEquals(other.pictures, pictures) &&
        other.category == category &&
        other.sellerNumber == sellerNumber &&
        other.sellerName == sellerName &&
        other.sellerStoreName == sellerStoreName &&
        other.isFav == isFav &&
        other.sale == sale &&
        other.quantity == quantity &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        pictures.hashCode ^
        category.hashCode ^
        sellerNumber.hashCode ^
        quantity.hashCode ^
        sellerName.hashCode ^
        sellerStoreName.hashCode ^
        isFav.hashCode ^
        sale.hashCode ^
        price.hashCode;
  }
}

class ColorImage {
  final String image;
  final String color;
  String? firebaseName;

  ColorImage({
    required this.image,
    required this.color,
    this.firebaseName,
  });

  ColorImage copyWith({
    String? image,
    String? color,
    String? firebaseName,
  }) {
    return ColorImage(
      image: image ?? this.image,
      color: color ?? this.color,
      firebaseName: firebaseName ?? this.firebaseName,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'image': image});
    result.addAll({'color': color});
    if (firebaseName != null) {
      result.addAll({'firebaseName': firebaseName});
    }

    return result;
  }

  factory ColorImage.fromMap(Map<String, dynamic> map) {
    return ColorImage(
      image: map['image'] ?? '',
      color: map['color'],
      firebaseName: map['firebaseName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorImage.fromJson(String source) =>
      ColorImage.fromMap(json.decode(source));

  @override
  String toString() =>
      'ColorImage(image: $image, color: $color, firebaseName: $firebaseName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColorImage &&
        other.image == image &&
        other.color == color &&
        other.firebaseName == firebaseName;
  }

  @override
  int get hashCode => image.hashCode ^ color.hashCode ^ firebaseName.hashCode;
}
